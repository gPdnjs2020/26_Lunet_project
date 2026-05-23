import 'package:flutter/material.dart';
import 'history_detail.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 상단
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    'Lunet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6480),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Image.asset('assets/images/character.png', width: 140),

              const SizedBox(height: 15),

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
                '우리가 함께 고민했던 소중한 순간들입니다.',
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 30),

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
        ),
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
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),

            const SizedBox(height: 20),

            Text(
              date,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
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

            const SizedBox(height: 18),

            const Text(
              '기록 자세히 보기 →',
              style: TextStyle(
                color: Color(0xFF4A6480),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
