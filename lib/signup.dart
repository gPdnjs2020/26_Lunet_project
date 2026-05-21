import 'package:flutter/material.dart';

/// [ 회원가입 화면 클래스 ]
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2), // Lunet 기본 배경색

      // 앱 상단 바 (뒤로 가기 버튼을 위해 추가)
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 배경 투명하게
        elevation: 0, // 그림자 없애기
        iconTheme: const IconThemeData(color: Color(0xFF4A6480)), // 뒤로 가기 화살표 색상
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// [ 1. 타이틀 영역 ]
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
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                /// [ 2. 정보 입력 필드 영역 ]
                _buildTextField('이름 (또는 닉네임)', Icons.person_outline),
                const SizedBox(height: 16),
                _buildTextField('이메일', Icons.email_outlined),
                const SizedBox(height: 16),
                _buildTextField('비밀번호', Icons.lock_outline, isPassword: true),
                const SizedBox(height: 16),
                _buildTextField('비밀번호 확인', Icons.lock_outline, isPassword: true),

                const SizedBox(height: 40),

                /// [ 3. 가입 완료 버튼 영역 ]
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF486A8A), Color(0xFFA9C7F2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF486A8A).withOpacity(0.3),
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
                    onPressed: () {
                      // TODO: 나중에 실제 회원가입 정보 저장 로직이 들어갈 곳입니다.
                      // 지금은 가입하기 버튼을 누르면 다시 로그인 화면으로 돌아가게 설정했습니다.
                      Navigator.pop(context);
                    },
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
                const SizedBox(height: 40), // 하단 여백
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// [ 입력창 디자인 공통 함수 ] (login.dart와 동일한 디자인 유지)
  Widget _buildTextField(String hintText, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF4A6480).withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
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
}