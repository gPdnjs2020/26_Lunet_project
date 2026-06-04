import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // 🌟 [추가] 현재 크롬(웹)인지 모바일인지 확인하는 패키지
import 'package:image_picker/image_picker.dart';
import '../../services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController nicknameController = TextEditingController();

  // 🌟 [수정] File 대신 XFile 타입 사용 (크롬 웹브라우저 호환성을 위해)
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
        _selectedImage = image; // 🌟 사진을 고르자마자 즉각 화면 리빌드!
      });
    }
  }

  /// 🖼️ [프로필 동그라미 안에 사진을 띄워주는 지능형 함수]
  ImageProvider _getAvatarImage() {
    // 1. 방금 내가 갤러리에서 새로 고른 사진이 있다면 가장 우선순위로 보여줌!
    if (_selectedImage != null) {
      if (kIsWeb) {
        // 🌟 크롬(웹) 환경에서는 사진을 NetworkImage로 읽어야 화면에 즉시 보입니다!
        return NetworkImage(_selectedImage!.path);
      } else {
        // 모바일(안드로이드/iOS) 환경
        return FileImage(File(_selectedImage!.path));
      }
    }
    // 2. 고른 사진이 없는데, 파이어베이스에 저장된 기존 내 사진이 있다면 그걸 보여줌!
    else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
      if (_existingImageUrl!.startsWith('http') ||
          _existingImageUrl!.startsWith('blob')) {
        return NetworkImage(_existingImageUrl!);
      } else {
        return FileImage(File(_existingImageUrl!));
      }
    }
    // 3. 둘 다 없으면 기본 루나 캐릭터 실루엣 띄우기!
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
                  backgroundImage: _getAvatarImage(), // 🌟 웹에서도 즉각 반영!
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

                          await ProfileService.saveNickname(
                            nicknameController.text,
                          );
                          await user?.updateDisplayName(
                            nicknameController.text,
                          );

                          if (_selectedImage != null) {
                            await ProfileService.saveProfileImage(
                              _selectedImage!.path,
                            );
                            await user?.updatePhotoURL(_selectedImage!.path);
                          }

                          await user?.reload();

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
