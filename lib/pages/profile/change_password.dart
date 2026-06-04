import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 패키지

// 🌟 로그아웃 후 이동할 로그인 페이지 경로 (본인의 프로젝트 경로에 맞게 확인해주세요)
import '../auth/login.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 🔒 [실제 Firebase 서버의 비밀번호 변경 및 자동 로그아웃 함수]
  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // 1. 기본 유효성 검사
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar('모든 빈칸을 입력해주세요.');
      return;
    }
    if (newPassword.length < 6) {
      _showSnackBar('새 비밀번호는 6자리 이상이어야 합니다.');
      return;
    }
    if (newPassword != confirmPassword) {
      _showSnackBar('새 비밀번호가 서로 일치하지 않습니다.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        // 🌟 [수정 1] getCredential -> credential 로 변경 (최신 firebase_auth 문법)
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // 실제 비밀번호 변경 실행
        await user.updatePassword(newPassword);

        // 변경 완료 직후 강제 로그아웃 처리
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          _showSnackBar('비밀번호가 변경되었습니다. 새 비밀번호로 다시 로그인해 주세요! 🔒');

          // 모든 라우트(히스토리) 삭제하고 로그인 화면으로 이동
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      } else {
        _showSnackBar('로그인 정보가 유실되었습니다. 다시 로그인 해주세요.');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase 패스워드 변경 에러 코드: ${e.code}");
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showSnackBar('현재 비밀번호가 틀렸습니다. 다시 확인해주세요.');
      } else {
        _showSnackBar('오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      _showSnackBar('네트워크 오류가 발생했습니다.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4A6480),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// 🎨 [공통 텍스트 필드 스타일 디자인]
  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true, // 비밀번호 숨기기
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF4A6480), width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A6480)),
        title: const Text(
          '비밀번호 변경',
          style: TextStyle(
            color: Color(0xFF4A6480),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '비밀번호 변경 🔒',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '실제 데이터베이스(Firebase)의 비밀번호를 안전하게 수정합니다.\n변경 후에는 안전을 위해 자동으로 로그아웃됩니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 35),

            // 🌟 [수정 2] Padding이 아니라 Text 위젯 안으로 style을 이동했습니다.
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                "현재 비밀번호",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),
            ),
            _buildTextField('현재 사용 중인 비밀번호 입력', _currentPasswordController),

            const SizedBox(height: 24),

            // 🌟 [수정 3] 여기도 Text 위젯 안으로 style 이동
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                "새로운 비밀번호",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),
            ),
            _buildTextField('새로 사용할 비밀번호 입력 (6자리 이상)', _newPasswordController),
            const SizedBox(height: 16),
            _buildTextField('새 비밀번호 재입력 확인', _confirmPasswordController),

            const SizedBox(height: 45),

            Container(
              width: double.infinity,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  colors: [Color(0xFF486A8A), Color(0xFFA9C7F2)],
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: _isLoading ? null : _changePassword,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '비밀번호 변경',
                        style: TextStyle(
                          fontSize: 18,
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
