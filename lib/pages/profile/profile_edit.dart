import 'package:flutter/material.dart';
import '../../services/profile_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController nicknameController = TextEditingController(
    text: "루넷 사용자",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(title: const Text("프로필 수정")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    'assets/images/user_avatar_placeholder.png',
                  ),
                ),

                Positioned(
                  right: 0,
                  bottom: 0,

                  child: GestureDetector(
                    onTap: () {
                      // 이미지 변경
                    },

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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () async {
                  await ProfileService.saveNickname(nicknameController.text);

                  Navigator.pop(context);
                },

                child: const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
