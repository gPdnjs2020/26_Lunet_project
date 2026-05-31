import 'package:flutter/material.dart';
import '../../model/history_model.dart';
import '../../services/history_service.dart';

class HistoryDetailPage extends StatelessWidget {
  final HistoryModel history;
  final int index;

  const HistoryDetailPage({
    super.key,
    required this.history,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await HistoryService.deleteHistoryByIndex(index);

              if (context.mounted) {
                Navigator.pop(context); // 삭제 후 뒤로가기

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('기록이 삭제되었습니다')));
              }
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 캐릭터
                Container(
                  width: 180,
                  height: 180,

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
                    child: Image.asset(
                      'assets/images/character.png',
                      width: 145,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// 말풍선
                Container(
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D8FF),

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Text(
                    '${history.title} 결과가 궁금해!\n루나가 기다리고 있었어요 ✨',

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// 결과 카드
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(35),

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
                      const Text(
                        'ORIGINAL PREDICTION',

                        style: TextStyle(
                          color: Colors.black45,

                          fontWeight: FontWeight.bold,

                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        history.title,

                        style: const TextStyle(
                          fontSize: 30,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${history.successRate}%',

                        style: const TextStyle(
                          fontSize: 54,

                          fontWeight: FontWeight.bold,

                          color: Color(0xFF4A6480),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        history.category,

                        style: const TextStyle(
                          fontSize: 16,

                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        history.date,

                        style: const TextStyle(
                          fontSize: 14,

                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// 상황 설명
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        '고민 내용',

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        history.situation,

                        style: const TextStyle(fontSize: 15, height: 1.6),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  '실제로 어떻게 되었나요?',

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

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

                    const SizedBox(width: 16),

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

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _resultCard({required String emoji, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),

            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 42)),

          const SizedBox(height: 12),

          Text(
            title,

            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
