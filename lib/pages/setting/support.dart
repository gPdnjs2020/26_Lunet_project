import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A6480)),
        title: const Text(
          '고객센터',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A6480),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // 앱 로고 또는 아이콘
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                size: 50,
                color: Color(0xFF4A6480),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '무엇을 도와드릴까요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334A66),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              '앱 이용 중 불편한 점이나 건의사항이 있다면\n언제든지 개발팀으로 연락해 주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // 개발자 정보 카드
            _buildInfoCard(
              title: '개발자 정보',
              items: [
                _buildInfoRow(Icons.person_outline, '이름', '손영웅, 신혜원'),
                _buildInfoRow(Icons.code_rounded, '버전', 'v1.0.0 (Beta)'),
              ],
            ),

            const SizedBox(height: 20),

            // 연락처 정보 카드
            _buildInfoCard(
              title: '연락처',
              items: [
                _buildInfoRow(
                  Icons.email_outlined,
                  '이메일',
                  'slt01091616@gmail.com',
                ),
                _buildInfoRow(Icons.email_outlined, '이메일', '신혜원@gmail.com'),
              ],
            ),

            const SizedBox(height: 40),

            // 하단 응원 문구
            const Text(
              '루넷은 여러분의 소중한 의견으로 성장합니다 ✨',
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }

  // 정보 카드 공통 레이아웃
  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
          const SizedBox(height: 20),
          ...items,
        ],
      ),
    );
  }

  // 내부 텍스트 행 레이아웃
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4A6480).withOpacity(0.6)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B5675),
            ),
          ),
        ],
      ),
    );
  }
}
