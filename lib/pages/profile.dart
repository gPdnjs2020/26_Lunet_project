import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// 분석 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),

              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  const Color(0xFFE2E9F3).withOpacity(0.6),
                  const Color(0xFFF3F1ED),
                ],
              ),
            ),

            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,

                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),

                      child: const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          'assets/images/user_avatar_placeholder.png',
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF9D6DC),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: const Text(
                        'LEVEL 12',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD65A7F),
                        ),
                      ),
                    ),
                  ],
                ),

                const Text(
                  '당신은 생각보다 신중한\n사람이에요 😊',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334A66),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '루나가 분석한 당신의 결정 스타일',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFD9E4EE),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 18,
                        color: Color(0xFF4A6480),
                      ),

                      SizedBox(width: 6),

                      Text(
                        '깊은 통찰의 분석가',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6480),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 통계 카드
          Row(
            children: [
              Expanded(
                child: _statCard(
                  title: '평균 성공률',
                  value: '54%',
                  icon: Icons.trending_up,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _statCard(
                  title: '가장 많이 고민한 분야',
                  value: '연애',
                  icon: Icons.favorite_border,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 조언 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: const Color(0xFFFCEFEF),
              borderRadius: BorderRadius.circular(24),
            ),

            child: const Text(
              '"지난 주 당신은 총 12번의 어려운 결정을 내렸어요.\n스스로를 믿으셔도 좋아요 ✨"',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7A5252),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// 최근 기록
          const Text(
            '최근의 발자취',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          _historyItem(
            emoji: '🍴',
            title: '오늘 저녁 메뉴 결정',
            subtitle: '2시간 전 · 완료',
          ),

          const SizedBox(height: 12),

          _historyItem(
            emoji: '💼',
            title: '이직 제안에 대한 답변',
            subtitle: '어제 · 진행 중',
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  static Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: const Color(0xFF4A6480),
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B5675),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _historyItem({
    required String emoji,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F3F0),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),

            alignment: Alignment.center,

            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}