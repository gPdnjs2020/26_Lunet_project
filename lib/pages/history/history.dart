import 'package:flutter/material.dart';
import 'history_detail.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          /// 캐릭터
          Container(
            width: 170,
            height: 170,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.7),

              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A6480).withOpacity(0.08),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),

            child: Center(
              child: Image.asset('assets/images/character.png', width: 140),
            ),
          ),

          const SizedBox(height: 25),

          /// 제목
          const Text(
            '그날의 선택',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            '우리가 함께 고민했던 소중한 순간들이에요 ✨',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
          ),

          const SizedBox(height: 35),

          /// 기록 카드들
          _historyCard(
            context,
            icon: Icons.favorite,
            color: Colors.pink,
            title: '고백하기',
            percent: '32%',
            date: 'MAY 14, 2024',
          ),

          const SizedBox(height: 20),

          _historyCard(
            context,
            icon: Icons.work,
            color: Colors.blue,
            title: '이직하기',
            percent: '78%',
            date: 'APRIL 28, 2024',
          ),

          const SizedBox(height: 20),

          _historyCard(
            context,
            icon: Icons.flight,
            color: Colors.purple,
            title: '혼자 여행 떠나기',
            percent: '92%',
            date: 'MARCH 12, 2024',
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _historyCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String percent,
    required String date,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HistoryDetailPage()),
        );
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// 아이콘
            Container(
              width: 54,
              height: 54,

              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: color),
            ),

            const SizedBox(height: 22),

            /// 날짜
            Text(
              date,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black45,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            /// 제목 + 퍼센트
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3FF),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    '$percent Prediction',
                    style: const TextStyle(
                      color: Color(0xFF4A6480),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 하단 버튼 느낌
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

              decoration: BoxDecoration(
                color: const Color(0xFFF7F5F2),
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    '기록 자세히 보기',
                    style: TextStyle(
                      color: Color(0xFF4A6480),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF4A6480),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
