import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// [ 회원가입 화면 클래스 ]
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  /// 입력값 저장용 controller
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// 회원가입 함수
  Future<void> signUp() async {
    /// 비밀번호 확인 검사
    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호가 일치하지 않습니다'),
        ),
      );
      return;
    }

    try {
      /// Firebase 회원가입
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      /// 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원가입 성공 ✨'),
        ),
      );

      /// 홈 이동
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = '비밀번호가 너무 약합니다';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 가입된 이메일입니다';
      } else if (e.code == 'invalid-email') {
        message = '올바른 이메일 형식이 아닙니다';
      } else {
        message = '회원가입 실패';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF4A6480),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                /// 제목
                const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Lunet과 함께 새로운 여정을 시작해보세요 ✨',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 40),

                /// 이름
                _buildTextField(
                  '이름 (또는 닉네임)',
                  Icons.person_outline,
                  controller: nameController,
                ),

                const SizedBox(height: 16),

                /// 이메일
                _buildTextField(
                  '이메일',
                  Icons.email_outlined,
                  controller: emailController,
                ),

                const SizedBox(height: 16),

                /// 비밀번호
                _buildTextField(
                  '비밀번호',
                  Icons.lock_outline,
                  isPassword: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 16),

                /// 비밀번호 확인
                _buildTextField(
                  '비밀번호 확인',
                  Icons.lock_outline,
                  isPassword: true,
                  controller: confirmPasswordController,
                ),

                const SizedBox(height: 40),

                /// 가입 버튼
                Container(
                  width: double.infinity,
                  height: 60,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF486A8A),
                        Color(0xFFA9C7F2),
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF486A8A,
                        ).withOpacity(0.3),

                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    onPressed: signUp,

                    child: const Text(
                      '가입하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 입력창 공통 함수
  Widget _buildTextField(
    String hintText,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,

      decoration: InputDecoration(
        hintText: hintText,

        prefixIcon: Icon(
          icon,
          color: const Color(
            0xFF4A6480,
          ).withOpacity(0.7),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
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

          borderSide: const BorderSide(
            color: Color(0xFF4A6480),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}