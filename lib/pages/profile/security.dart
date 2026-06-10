import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'change_password.dart';
import '../auth/login.dart'; // ⭐ [수정] 로그인 페이지를 직접 임포트합니다 (경로를 프로젝트 구조에 맞게 확인해 주세요!)

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  /// 🗑️ [계정 삭제 및 즉시 로그아웃 처리 함수]
  Future<void> _deleteAccount(BuildContext context) async {
    // 1. 유저에게 정말 삭제할 것인지 다이얼로그로 확인 인증 받기
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '계정 삭제',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '정말 계정을 삭제하시겠습니까?\n삭제된 계정과 모든 데이터는 복구할 수 없습니다.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // 취소
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // 삭제 승인
            child: const Text(
              '삭제',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    // 2. 유저가 '삭제'를 최종 승인한 경우
    if (confirm == true) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // 🔥 [서버 처리 1] Firebase Auth 서버에서 계정 완전 삭제
          await user.delete();

          // 🔥 [서버 처리 2] 혹시 모를 인증 토큰 찌꺼기까지 서버 및 로컬에서 완전 초기화 (로그아웃)
          await FirebaseAuth.instance.signOut();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('계정이 완전히 삭제되었습니다. 이용해 주셔서 감사합니다.')),
            );

            // 🚀 [화면 처리] 그동안 열려있던 모든 화면(홈, 마이페이지 등)을 싹 닫아버리고 로그인 화면 하나만 새로 띄우기!
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ), // LoginPage 객체로 직접 안전하게 이동
              (route) => false, // 기존 화면 스택을 true로 남기지 않고 다 폭파(false)시킵니다.
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        // 보안 에러 처리: 오랫동안 로그인 상태여서 재인증이 필요한 경우
        if (e.code == 'requires-recent-login') {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('보안을 위해 다시 로그인한 후 탈퇴를 진행해 주세요.')),
            );
            // 안전하게 로그아웃 시키고 로그인 창으로 강제 이동
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: ${e.message}')));
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('알 수 없는 오류가 발생하여 계정 삭제에 실패했습니다.')),
          );
        }
      }
    }
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
          '보안 및 개인정보',
          style: TextStyle(
            color: Color(0xFF4A6480),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _card(
              icon: Icons.lock_outline,
              title: '비밀번호 변경',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _card(
              icon: Icons.delete_outline,
              title: '계정 삭제',
              onTap: () => _deleteAccount(context), // 완성된 완벽한 탈퇴 로직 연결
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4A6480)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
