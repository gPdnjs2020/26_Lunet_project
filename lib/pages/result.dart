import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';
import 'strategy.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    const double successRate = 0.4;

    return MainLayout(
      currentIndex: 0,

      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),

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

            const SizedBox(height: 24),

            const Text(
              '지금은 약 40% 정도\n가능해 보여요!',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: Color(0xFF2B2B2B),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              '루넷이 당신의 상황과 감정을 분석해봤어요 ✨',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 24),

            /// 성공률 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),

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
                children: [
                  const Text(
                    'SUCCESS RATE',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 13,
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Stack(
                    alignment: Alignment.center,

                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,

                        child: CircularProgressIndicator(
                          value: successRate,
                          strokeWidth: 13,
                          backgroundColor: Colors.blueGrey.shade50,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF4A6480),
                          ),
                        ),
                      ),

                      const Column(
                        children: [
                          Text(
                            '40%',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A6480),
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            '가능성',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3FF),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF4A6480),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            '조금 더 확신을 가지고 접근하면 성공 가능성이 높아질 수 있어요 ✨',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 분석 카드
            Row(
              children: [
                Expanded(
                  child: _analysisCard(
                    title: '긍정 요소',
                    icon: Icons.favorite,
                    color: const Color(0xFFE9A5AF),
                    content: '상대방과의 분위기가 나쁘지 않아요.',
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _analysisCard(
                    title: '주의 요소',
                    icon: Icons.lightbulb,
                    color: const Color(0xFFA9C7F2),
                    content: '조금 더 타이밍을 보는 것도 좋아요.',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// 조언 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: const Color(0xFFE9D8FF),
                borderRadius: BorderRadius.circular(35),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.psychology_alt,
                        color: Color(0xFF7E57C2),
                      ),

                      SizedBox(width: 10),

                      Text(
                        '루넷의 조언',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7E57C2),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    '당신은 이미 충분히 용기 있는 사람이에요.\n결과보다 중요한 건 스스로의 마음을 솔직하게 전하는 거예요 💜',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 수정 전략 버튼
            SizedBox(
              width: double.infinity,
              height: 65,

              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF4A6480),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StrategyPage(),
                    ),
                  );
                },

                child: const Text(
                  '수정 전략 알아보기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 다시 분석 버튼
            Container(
              width: double.infinity,
              height: 65,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),

                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF486A8A),
                    Color(0xFFA9C7F2),
                  ],
                ),
              ),

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),

                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },

                child: const Text(
                  '다시 분석하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              '루넷은 언제나 당신의 선택을 응원해요 🌙',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _analysisCard({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}