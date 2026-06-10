import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/profile_service.dart'; // ⭐ [추가] ProfileService 불러오기

/// [ 회원가입 화면 클래스 ]
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  /// 입력값 저장용 controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// ⭐ [추가] 생년월일과 성별을 저장할 변수
  final TextEditingController birthdateController = TextEditingController();
  String? _selectedGender;

  /// 회원가입 함수
  Future<void> signUp() async {
    /// 비밀번호 확인 검사
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다')));
      return;
    }

    /// 필수 입력값 확인 (선택 사항)
    if (nameController.text.isEmpty ||
        birthdateController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 정보를 입력해주세요')));
      return;
    }

    try {
      /// Firebase 회원가입 (이메일, 비밀번호)
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      /// 💡 참고: 이름(nameController.text), 생년월일(birthdateController.text),
      /// 성별(_selectedGender)은 Firebase Auth에 바로 들어가지 않으므로,
      /// 실제 앱에서는 이 타이밍에 Firebase Firestore나 Realtime DB에 추가로 저장해주어야 합니다!
      // ==========================================
      // ⭐ 기기(ProfileService)에 내 정보 저장하기
      await userCredential.user?.updateDisplayName(nameController.text.trim());
      await ProfileService.saveNickname(nameController.text.trim());
      await ProfileService.saveBirthdate(birthdateController.text.trim());
      if (_selectedGender != null) {
        await ProfileService.saveGender(_selectedGender!);
      }
      // ==========================================
      /// 성공 메시지
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('회원가입 성공 ✨')));

        /// 홈 이동
        Navigator.pushReplacementNamed(context, '/home');
      }
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

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  /// ⭐ [추가] 생년월일 선택 달력 띄우기 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // 초기 날짜
      firstDate: DateTime(1900), // 선택 가능한 가장 빠른 날짜
      lastDate: DateTime.now(), // 선택 가능한 가장 늦은 날짜 (오늘)
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A6480), // 달력 헤더 색상
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // 선택한 날짜를 YYYY-MM-DD 형식으로 텍스트 필드에 입력
        birthdateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A6480)),
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
                  style: TextStyle(fontSize: 16, color: Colors.black54),
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

                /// ⭐ [추가] 생년월일 (클릭 시 달력 팝업)
                _buildTextField(
                  '생년월일',
                  Icons.calendar_today_outlined,
                  controller: birthdateController,
                  readOnly: true, // 직접 타이핑 방지
                  onTap: () => _selectDate(context), // 탭했을 때 달력 열기
                ),
                const SizedBox(height: 16),

                /// ⭐ [추가] 성별 (드롭다운)
                _buildDropdownField('성별', Icons.people_outline),
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

  /// 입력창 공통 함수 (기존 코드에서 readOnly, onTap 기능 추가)
  Widget _buildTextField(
    String hintText,
    IconData icon, {
    bool isPassword = false,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly, // ⭐ 추가 (달력 텍스트 필드를 위해)
      onTap: onTap, // ⭐ 추가 (달력 텍스트 필드를 위해)
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

  /// ⭐ [추가] 성별 선택용 드롭다운 위젯 (기존 입력창과 디자인 통일)
  Widget _buildDropdownField(String hintText, IconData icon) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
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
      items: ['남성', '여성', '선택 안 함']
          .map((label) => DropdownMenuItem(value: label, child: Text(label)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
    );
  }
}
