import 'package:flutter/material.dart';

/// [ 메인 클래스 ]
/// 로그인 화면 전체를 구성하는 메인 화면 위젯입니다.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  /// [ 전체 UI 빌드 함수 ]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2), // 앱 전체 배경색 설정

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// [ 1. 앱 로고 및 서비스명 영역 ]
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lunet',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '당신만의 새로운 공간, 루넷',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 20), // 여백 조정 (60 -> 50)
                /// [ 2. 소셜 로그인 영역 ] - ★이 부분이 수정되었습니다!★
                /// 이제 거대한 원형 버튼이 아니라, 표준 알약 모양 버튼으로 그립니다.
                _buildGoogleLoginButton(context),

                const SizedBox(height: 30),

                /// [ 3. 화면 구분선 영역 ]
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade400, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade400, thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// [ 4. 이메일 & 비밀번호 입력 영역 ]
                _buildTextField('이메일', Icons.email_outlined),
                const SizedBox(height: 16),
                _buildTextField('비밀번호', Icons.lock_outline, isPassword: true),

                const SizedBox(height: 40),

                /// [ 5. 메인 로그인 버튼 영역 ]
                Container(
                  width: double.infinity,
                  height: 40,
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
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// [ 6. 회원가입 유도 영역 ]
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '아직 Lunet의 회원이 아니신가요?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color: Color(0xFF4A6480),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------- //
  // [ 커스텀 기능 함수 모음 ]
  // ---------------------------------------------------------------------- //

  /// [ 기능 1: 텍스트 입력창 공통 함수 ]
  Widget _buildTextField(
    String hintText,
    IconData icon, {
    bool isPassword = false,
  }) {
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

  /// [ 기능 2: ★수정된 구글 로그인 버튼 전용 함수★ ]
  /// 거대한 원형 버튼을 버리고, 표준 알약 모양 버튼으로 디자인을 완전히 수정했습니다.
  /// 로고 크기를 키우고 글자를 함께 조립했습니다.
  Widget _buildGoogleLoginButton(BuildContext context) {
    return Container(
      width: 280, // 버튼 전체 가로 크기를 적절하게 제한 (원형이 되지 않게 함)
      height: 55, // 버튼 높이 설정
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27.5), // 완벽한 알약 모양을 위한 라운딩
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(27.5),
          onTap: () {
            // ✨ onPressed를 onTap으로 변경해 주세요!
            // TODO: 나중에 구글 연동 로직
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // 내부 여백
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. 구글 'G' 로고 (로컬 이미지로 변경!)
                Image.asset(
                  'assets/images/Google_logo.png', // 파일의 실제 확장자에 맞게 .png 또는 .jpg를 적어주세요.
                  height: 28,
                ),
                const SizedBox(width: 8), // 로고와 텍스트 사이 간격
                // 2. 로그인 안내 텍스트
                const Text(
                  '로 계속하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
