import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // 🌟 [핵심 추가] 파이어베이스 스토리지

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController nicknameController = TextEditingController();

  /// ⭐ [수정] 생년월일 3분할 컨트롤러
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  /// ⭐ [추가] 성별 컨트롤러 (수정 불가용)
  final TextEditingController genderController = TextEditingController();

  XFile? _selectedImage;
  String? _existingImageUrl;

  bool _isLoading = false;
  bool _isGoogleUser = false; // 구글 로그인 여부

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    nicknameController.text = user?.displayName ?? "루넷 사용자";
    _existingImageUrl = user?.photoURL;

    // 구글 연동 로그인인지 확인
    if (user != null) {
      for (var userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          _isGoogleUser = true;
          break;
        }
      }
    }

    // ⭐ [임시 데이터] 실제 DB에서 정보를 불러오면 이 곳에 넣어주세요!
    genderController.text = '선택 안 함'; // 성별 초기값 셋팅
    _loadSavedData(); //생년월일 불러오기
  }

  @override
  void dispose() {
    nicknameController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    try {
      // 1. 생년월일 불러오기
      String? savedDate = await ProfileService.getBirthdate();

      if (savedDate != null && savedDate.isNotEmpty) {
        List<String> dateParts = savedDate.split('-');

        if (dateParts.length == 3) {
          setState(() {
            yearController.text = dateParts[0];
            monthController.text = dateParts[1];
            dayController.text = dateParts[2];
          });
        }
      }

      // 2. ⭐ 성별 불러오기 추가!
      String? savedGender = await ProfileService.getGender();
      if (savedGender != null && savedGender.isNotEmpty) {
        setState(() {
          genderController.text = savedGender;
        });
      } else {
        setState(() {
          genderController.text = '선택 안 함'; // 저장된 게 없을 때 기본값
        });
      }

      // 3. ⭐ [추가] 닉네임도 기기에서 확실히 불러오기!
      String savedNickname = await ProfileService.loadNickname();
      User? user = FirebaseAuth.instance.currentUser;

      setState(() {
        // 파이어베이스 이름이 비어있으면 기기에 저장된 이름으로 채워 넣음
        nicknameController.text =
            (user?.displayName != null && user!.displayName!.isNotEmpty)
            ? user.displayName!
            : savedNickname;
      });
    } catch (e) {
      debugPrint("정보 불러오기 에러: $e");
    }
  }

  /// 📸 갤러리 이미지 선택 함수
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  /// 🖼️ 아바타 이미지 렌더링 함수
  ImageProvider _getAvatarImage() {
    if (_selectedImage != null) {
      if (kIsWeb) {
        return NetworkImage(_selectedImage!.path);
      } else {
        return FileImage(File(_selectedImage!.path));
      }
    } else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
      if (_existingImageUrl!.startsWith('http') ||
          _existingImageUrl!.startsWith('blob')) {
        return NetworkImage(_existingImageUrl!);
      } else {
        return FileImage(File(_existingImageUrl!));
      }
    }
    return const AssetImage('assets/images/user_avatar_placeholder.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        title: const Text(
          "프로필 수정",
          style: TextStyle(
            color: Color(0xFF4A6480),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A6480)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: _getAvatarImage(),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A6480),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ⭐ [수정] 3분할 생년월일 입력란
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                '생년월일',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDateBox(
                    controller: yearController,
                    hint: 'YYYY',
                    maxLength: 4,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: _buildDateBox(
                    controller: monthController,
                    hint: 'MM',
                    maxLength: 2,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: _buildDateBox(
                    controller: dayController,
                    hint: 'DD',
                    maxLength: 2,
                  ),
                ),
              ],
            ),
            if (_isGoogleUser)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  '구글 계정은 생년월일을 변경할 수 없습니다.',
                  style: TextStyle(
                    color: Colors.redAccent.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// ⭐ [추가] 성별 입력란 (항상 읽기 전용)
            TextField(
              controller: genderController,
              readOnly: true, // 영구적으로 타이핑 방지
              style: const TextStyle(color: Colors.black54),
              decoration: InputDecoration(
                labelText: '성별',
                hintText: '성별은 수정할 수 없습니다.',
                filled: true,
                fillColor: Colors.grey.shade300, // 시각적으로 닫혀있음을 표현
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// ⭐ [에러 방지용 안전장치가 추가된 저장 버튼]
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6480),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);

                        try {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user == null) throw Exception("로그인된 사용자가 없습니다.");

                          // 1. 닉네임 안전 검증 및 저장
                          String newNickname = nicknameController.text.trim();
                          if (newNickname.isNotEmpty) {
                            await ProfileService.saveNickname(newNickname);
                            await user.updateDisplayName(newNickname);
                          }

                          // 2. 생년월일 안전 검증 및 저장 (구글 유저가 아닐 때만)
                          if (!_isGoogleUser) {
                            String year = yearController.text.trim();
                            String month = monthController.text.trim();
                            String day = dayController.text.trim();

                            // 년/월/일 3칸이 '모두' 제대로 입력되었을 때만 합쳐서 저장!
                            if (year.isNotEmpty &&
                                month.isNotEmpty &&
                                day.isNotEmpty) {
                              String fullBirthdate = "$year-$month-$day";
                              // 실제 DB 연결 시 아래 주석을 해제하세요
                              await ProfileService.saveBirthdate(fullBirthdate);
                              debugPrint("저장될 생년월일: $fullBirthdate");
                            } else {
                              debugPrint("생년월일이 모두 입력되지 않아 저장하지 않습니다.");
                            }
                          }

                          // 3. 프로필 이미지 스토리지 업로드 (새 이미지를 골랐을 때만)
                          if (_selectedImage != null) {
                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child('profile_images')
                                .child('${user.uid}.jpg');

                            if (kIsWeb) {
                              final bytes = await _selectedImage!.readAsBytes();
                              await storageRef.putData(bytes);
                            } else {
                              await storageRef.putFile(
                                File(_selectedImage!.path),
                              );
                            }

                            final downloadUrl = await storageRef
                                .getDownloadURL();
                            await ProfileService.saveProfileImage(downloadUrl);
                            await user.updatePhotoURL(downloadUrl);
                          }

                          // 4. 파이어베이스 유저 정보 강제 새로고침
                          await user.reload();

                          // 5. 성공 시 안내 메시지와 함께 뒤로가기
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('프로필이 성공적으로 저장되었습니다 ✨'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          debugPrint("프로필 저장 에러: $e");
                          // 에러 났을 때 화면 하단에 에러 문구 띄우기
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('저장 중 오류가 발생했어요: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        '저장',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ⭐ 생년월일 박스 생성용 헬퍼 위젯
  Widget _buildDateBox({
    required TextEditingController controller,
    required String hint,
    required int maxLength,
  }) {
    return TextField(
      controller: controller,
      readOnly: _isGoogleUser, // 구글 유저면 읽기 전용으로 잠금
      keyboardType: TextInputType.number, // 숫자 패드 띄우기
      maxLength: maxLength,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        counterText: '', // 하단 글자 수 카운트 숨기기
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
        filled: true,
        fillColor: _isGoogleUser ? Colors.grey.shade300 : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
