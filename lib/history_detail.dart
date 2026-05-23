import 'package:flutter/material.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),

                    const Text(
                      'history',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF4A6480),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Image.asset('assets/images/character.png', width: 150),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D8FF),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const Text(
                    '고백하기 결과가 궁금해!\n루미르가 기다리고 있었어요 ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),

                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORIGINAL PREDICTION',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 18),

                      Text(
                        '고백하기',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        '32%',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6480),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  '실제로 어떻게 되었나요?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('루나가 당신의 성공을 축하해요 ❤️'),
                            ),
                          );
                        },

                        child: _resultCard(emoji: '❤️', title: '성공했어요!'),
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('다음엔 더 좋은 결과가 있을 거예요 🌙'),
                            ),
                          );
                        },

                        child: _resultCard(emoji: '🥲', title: '아쉬워요..'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _resultCard({required String emoji, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 35),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 42)),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
