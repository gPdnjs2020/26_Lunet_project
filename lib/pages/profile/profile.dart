import 'package:flutter/material.dart';
import '../../model/history_model.dart';
import '../../services/history_service.dart';
import '../history/history_detail.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<HistoryModel> histories = [];

  double avgRate = 0;
  String topCategory = '없음';

  String profileTitle = '새로운 탐험가';
  String profileStyle = '아직 분석 데이터가 없어요';

  int level = 1;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void analyzeProfile(List<HistoryModel> histories) {
    if (histories.isEmpty) return;

    double avgSuccess =
        histories.map((e) => e.successRate).reduce((a, b) => a + b) /
        histories.length;

    Map<String, int> categoryCount = {};

    for (var h in histories) {
      categoryCount[h.category] = (categoryCount[h.category] ?? 0) + 1;
    }

    String topCategory = categoryCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    if (avgSuccess >= 80) {
      profileTitle = '대담한 도전자';

      profileStyle = '당신은 결정을 빠르게 내리고 기회를 잡는 타입이에요 🚀';
    } else if (avgSuccess >= 60) {
      profileTitle = '균형 잡힌 전략가';

      profileStyle = '신중함과 실행력을 적절히 조화시키는 스타일이에요 ⚖️';
    } else {
      profileTitle = '깊은 통찰의 분석가';

      profileStyle = '충분히 고민한 뒤 움직이는 신중한 타입이에요 🔍';
    }

    if (topCategory == '연애') {
      profileStyle += '\n특히 인간관계와 감정 문제에 관심이 많아요 ❤️';
    }

    if (topCategory == '진로') {
      profileStyle += '\n미래와 성장에 대한 고민이 많아요 🚀';
    }

    if (topCategory == '공부') {
      profileStyle += '\n배움과 자기계발을 중요하게 생각해요 📚';
    }
  }

  Future<void> loadData() async {
    final result = await HistoryService.loadHistories();

    if (result.isEmpty) {
      return;
    }

    double average =
        result.map((e) => e.successRate).reduce((a, b) => a + b) /
        result.length;

    Map<String, int> categoryCount = {};

    for (var item in result) {
      categoryCount[item.category] = (categoryCount[item.category] ?? 0) + 1;
    }

    String mostCategory = categoryCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    setState(() {
      histories = result;
      avgRate = average;
      topCategory = mostCategory;

      level = (result.length ~/ 5) + 1;
      analyzeProfile(result);
    });
  }

  String getEmoji(String category) {
    switch (category) {
      case '연애':
        return '❤️';

      case '회사':
        return '💼';

      case '공부':
        return '📚';

      case '진로':
        return '🚀';

      case '가족':
        return '🏡';

      default:
        return '✨';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
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

                      child: Text(
                        'LEVEL $level',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD65A7F),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  profileStyle,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334A66),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '루나가 분석한 당신의 결정 스타일',
                  style: TextStyle(fontSize: 13, color: Colors.black45),
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

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        size: 18,
                        color: Color(0xFF4A6480),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        profileTitle,
                        style: const TextStyle(
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

          Row(
            children: [
              Expanded(
                child: _statCard(
                  title: '평균 성공률',
                  value: '${avgRate.toStringAsFixed(0)}%',
                  icon: Icons.trending_up,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _statCard(
                  title: '많이 고민한 분야',
                  value: topCategory,
                  icon: Icons.favorite_border,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: const Color(0xFFFCEFEF),
              borderRadius: BorderRadius.circular(24),
            ),

            child: Text(
              '지금까지 총 ${histories.length}번의 결정을 분석했어요.\n루넷은 당신의 선택을 기억하고 있어요 ✨',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A5252),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            '최근의 발자취',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 14),

          ...histories.reversed.take(3).map((history) {
            final index = histories.indexOf(history);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _historyItem(
                context: context,
                history: history,
                index: index,
                emoji: getEmoji(history.category),
                title: history.title,
                subtitle: history.date,
              ),
            );
          }),

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
              Icon(icon, size: 16, color: const Color(0xFF4A6480)),

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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B5675),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _historyItem({
    required BuildContext context,
    required HistoryModel history,
    required int index,
    required String emoji,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailPage(history: history, index: index),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

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

              child: Text(emoji, style: const TextStyle(fontSize: 20)),
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
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
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
      ),
    );
  }
}
