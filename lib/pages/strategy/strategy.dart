import 'package:flutter/material.dart';

class StrategyPage extends StatelessWidget {
  final Map<String, dynamic> aiResult;

  const StrategyPage({
    super.key,
    required this.aiResult,
  });

  @override
  Widget build(BuildContext context) {

    /// AI 전략 리스트
    final List strategies =
        aiResult['strategies'] ?? [];

    /// 현재 성공률
    final int currentRate =
        aiResult['success_rate'] ?? 50;

    /// boost 총합 계산
    int totalBoost = 0;

    for (var strategy in strategies) {
      totalBoost +=
          (strategy['boost'] ?? 0) as int;
    }

    /// 최대 99 제한
    final int improvedRate =
        (currentRate + totalBoost).clamp(0, 99);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Color(0xFF4A6480),
        ),

        title: const Text(
          '수정 전략',
          style: TextStyle(
            color: Color(0xFF4A6480),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// 상단 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFFE9D8FF),
                  borderRadius:
                      BorderRadius.circular(30),
                ),

                child: Row(
                  children: [

                    Image.asset(
                      'assets/images/character.png',
                      width: 80,
                    ),

                    const SizedBox(width: 20),

                    const Expanded(
                      child: Text(
                        '루나가 성공 가능성을 높이기 위한\n맞춤 전략을 분석했어요 ✨',

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

              const SizedBox(height: 32),

              /// 전략 리스트
              ...strategies.map(
                (strategy) {

                  final int boost =
                      strategy['boost'] ?? 0;

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 18,
                    ),

                    child: _strategyCard(
                      icon: _getIcon(
                        strategy['title'] ?? '',
                      ),

                      color: _getColor(
                        strategy['title'] ?? '',
                      ),

                      title:
                          strategy['title'] ?? '',

                      desc:
                          strategy['description'] ?? '',

                      boost: boost,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// 상승률 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(32),

                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    const Icon(
                      Icons.auto_awesome,
                      size: 34,
                      color: Color(0xFF4A6480),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      '현재는 약 $currentRate%의 가능성이 있지만\n'
                      '전략들을 잘 실천하면\n'
                      '$improvedRate%까지 성공 가능성을 높일 수 있어요 🌙',

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 19,
                        height: 1.7,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        _rateBox(
                          title: '현재',
                          value: '$currentRate%',
                        ),

                        const SizedBox(width: 16),

                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF4A6480),
                        ),

                        const SizedBox(width: 16),

                        _rateBox(
                          title: '예상',
                          value: '$improvedRate%',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// 전략 카드
  Widget _strategyCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required int boost,
  }) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        title,

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFE8F3FF),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),

                      child: Text(
                        '+$boost%',

                        style: const TextStyle(
                          color: Color(0xFF4A6480),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  desc,

                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 퍼센트 박스
  Widget _rateBox({
    required String title,
    required String value,
  }) {

    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F2),
        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        children: [

          Text(
            title,

            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,

            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
        ],
      ),
    );
  }

  /// 아이콘
  IconData _getIcon(String title) {

    if (title.contains('감정')) {
      return Icons.favorite;
    }

    if (title.contains('타이밍')) {
      return Icons.schedule;
    }

    if (title.contains('대화')) {
      return Icons.chat_bubble_outline;
    }

    if (title.contains('자신감')) {
      return Icons.psychology;
    }

    return Icons.auto_awesome;
  }

  /// 색상
  Color _getColor(String title) {

    if (title.contains('감정')) {
      return const Color(0xFFE9A5AF);
    }

    if (title.contains('타이밍')) {
      return const Color(0xFFA9C7F2);
    }

    if (title.contains('대화')) {
      return const Color(0xFFB8A8E6);
    }

    if (title.contains('자신감')) {
      return const Color(0xFFFFC107);
    }

    return const Color(0xFF4A6480);
  }
}