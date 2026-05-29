import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// ----------------------------------------------------------
/// 로그인 페이지
/// ----------------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// 이메일 / 비밀번호 입력 컨트롤러
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  /// Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ----------------------------------------------------------
  /// 이메일 로그인
  /// ----------------------------------------------------------
  Future<void> signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    } on FirebaseAuthException catch (e) {
      String message = '로그인 실패';

      if (e.code == 'user-not-found') {
        message = '존재하지 않는 이메일입니다.';
      } else if (e.code == 'wrong-password') {
        message = '비밀번호가 올바르지 않습니다.';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식이 올바르지 않습니다.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  /// ----------------------------------------------------------
  /// 구글 로그인
  /// ----------------------------------------------------------
  Future<void> signInWithGoogle() async {
    try {
      /// 구글 로그인 객체 생성
      final GoogleSignIn googleSignIn = GoogleSignIn();

      /// 구글 로그인창 띄우기
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      /// 취소 시 종료
      if (googleUser == null) return;

      /// 구글 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      /// Firebase credential 생성
      final OAuthCredential credential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      /// Firebase 로그인
      await _auth.signInWithCredential(
        credential,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '구글 로그인 실패\n$e',
          ),
        ),
      );
    }
  }

  /// ----------------------------------------------------------
  /// 화면 UI
  /// ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                /// 로고
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(
                    'assets/images/logo.png',
                  ),
                  backgroundColor:
                      Colors.transparent,
                ),

                const SizedBox(height: 16),

                /// 앱 이름
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                /// 구글 로그인 버튼
                _buildGoogleLoginButton(),

                const SizedBox(height: 30),

                /// 구분선
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color:
                            Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      child: Text(
                        '또는',
                        style: TextStyle(
                          color: Colors
                              .grey.shade600,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color:
                            Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// 이메일 입력
                _buildTextField(
                  controller: emailController,
                  hintText: '이메일',
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 16),

                /// 비밀번호 입력
                _buildTextField(
                  controller:
                      passwordController,
                  hintText: '비밀번호',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 40),

                /// 로그인 버튼
                Container(
                  width: double.infinity,
                  height: 55,

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),

                    gradient:
                        const LinearGradient(
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
                        offset:
                            const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent,

                      shadowColor:
                          Colors.transparent,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(30),
                      ),
                    ),

                    onPressed: signIn,

                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 회원가입 이동
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Text(
                      '아직 Lunet의 회원이 아니신가요?',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/signup',
                        );
                      },

                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          color:
                              Color(0xFF4A6480),
                          fontWeight:
                              FontWeight.bold,
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

  /// ----------------------------------------------------------
  /// 텍스트 입력창
  /// ----------------------------------------------------------
  Widget _buildTextField({
    required TextEditingController
        controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
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

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),

          borderSide: BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),

          borderSide: BorderSide.none,
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),

          borderSide: const BorderSide(
            color: Color(0xFF4A6480),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// 구글 로그인 버튼
  /// ----------------------------------------------------------
  Widget _buildGoogleLoginButton() {
    return Container(
      width: 280,
      height: 55,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(27.5),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius:
              BorderRadius.circular(27.5),

          onTap: signInWithGoogle,

          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Image.asset(
                  'assets/images/Google_logo.png',
                  height: 28,
                ),

                const SizedBox(width: 10),

                const Text(
                  '로 계속하기',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight:
                        FontWeight.w500,
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