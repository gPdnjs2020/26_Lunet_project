import 'package:flutter/material.dart';

class StrategyPage extends StatelessWidget {
  const StrategyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A6480)),
        title: const Text(
          '수정 전략',
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
            /// 캐릭터 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: const Color(0xFFE9D8FF),
                borderRadius: BorderRadius.circular(30),
              ),

              child: Row(
                children: [
                  Image.asset('assets/images/character.png', width: 80),

                  const SizedBox(width: 20),

                  const Expanded(
                    child: Text(
                      '성공 확률을 높이기 위한\n루넷의 전략을 알려줄게요 ✨',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _strategyCard(
              icon: Icons.favorite,
              color: Color(0xFFE9A5AF),
              title: '감정 표현 더하기',
              desc: '상대방에게 조금 더 솔직하게 감정을 표현해보세요.',
            ),

            const SizedBox(height: 18),

            _strategyCard(
              icon: Icons.schedule,
              color: Color(0xFFA9C7F2),
              title: '타이밍 조절하기',
              desc: '상대가 여유로운 순간을 기다리는 것이 좋아요.',
            ),

            const SizedBox(height: 18),

            _strategyCard(
              icon: Icons.chat_bubble_outline,
              color: Color(0xFFB8A8E6),
              title: '대화 빈도 늘리기',
              desc: '조금 더 자연스럽게 대화를 이어가보세요.',
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: const Column(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF4A6480), size: 30),

                  SizedBox(height: 15),

                  Text(
                    '현재 전략을 잘 반영하면\n성공 가능성이 40% → 65%까지 상승할 수 있어요 🌙',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.7,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _strategyCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),

      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
