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

  XFile? _selectedImage;
  String? _existingImageUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    nicknameController.text = user?.displayName ?? "루넷 사용자";
    _existingImageUrl = user?.photoURL;
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  /// 📸 [갤러리를 열어서 이미지를 골라오는 함수]
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  /// 🖼️ [프로필 동그라미 안에 사진을 띄워주는 지능형 함수]
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
          children: [
            Stack(
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

            const SizedBox(height: 30),

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

                          // 1. 닉네임 변경 (서버 및 로컬)
                          await ProfileService.saveNickname(
                            nicknameController.text,
                          );
                          await user.updateDisplayName(nicknameController.text);

                          // 2. 🌟 [핵심] 갤러리에서 새로 고른 사진을 진짜 Firebase Storage 서버에 업로드!
                          if (_selectedImage != null) {
                            // 내 유저 고유 ID(uid)로 파일 이름을 만들어 덮어씌웁니다.
                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child('profile_images')
                                .child('${user.uid}.jpg');

                            // 웹과 모바일의 업로드 방식 차이 해결
                            if (kIsWeb) {
                              final bytes = await _selectedImage!.readAsBytes();
                              await storageRef.putData(bytes);
                            } else {
                              await storageRef.putFile(
                                File(_selectedImage!.path),
                              );
                            }

                            // 3. 업로드가 완료되면 영구적인 다운로드 URL(https://...)을 발급받습니다!
                            final downloadUrl = await storageRef
                                .getDownloadURL();

                            // 4. 발급받은 진짜 인터넷 주소를 내 파이어베이스 계정 프로필에 저장합니다!
                            await ProfileService.saveProfileImage(downloadUrl);
                            await user.updatePhotoURL(downloadUrl);
                          }

                          // 서버 데이터 강제 새로고침
                          await user.reload();

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          debugPrint("프로필 저장 에러: $e");
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
}
