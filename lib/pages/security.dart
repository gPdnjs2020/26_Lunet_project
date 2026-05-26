import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

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
            ),

            const SizedBox(height: 16),

            _card(
              icon: Icons.visibility_off_outlined,
              title: '개인정보 관리',
            ),

            const SizedBox(height: 16),

            _card(
              icon: Icons.delete_outline,
              title: '계정 삭제',
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
  }) {
    return Container(
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

          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}