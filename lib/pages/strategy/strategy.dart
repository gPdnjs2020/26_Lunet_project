import 'package:flutter/material.dart';

class StrategyPage extends StatelessWidget {
  final Map<String, dynamic> aiResult;

  const StrategyPage({
    super.key,
    required this.aiResult,
  });

  @override
  Widget build(BuildContext context) {
    final List strategies = aiResult['strategies'] ?? [];

    final int currentRate =
        (aiResult['successRate'] ?? 40);

    final int improvedRate =
        (aiResult['improvedRate'] ?? 65);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            const IconThemeData(
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
                        '성공 확률을 높이기 위한\n루나의 전략을 알려줄게요 ✨',
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

              /// 전략 리스트
              if (strategies.isNotEmpty)
                ...strategies.map(
                  (strategy) => Padding(
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
                          strategy['title'] ??
                          '전략',

                      desc:
                          strategy['description'] ??
                          '',
                    ),
                  ),
                ),

              /// 전략 없을 경우
              if (strategies.isEmpty)
                Column(
                  children: [
                    _strategyCard(
                      icon: Icons.favorite,
                      color:
                          const Color(0xFFE9A5AF),
                      title: '감정 표현 더하기',
                      desc:
                          '상대방에게 조금 더 솔직하게 감정을 표현해보세요.',
                    ),

                    const SizedBox(height: 18),

                    _strategyCard(
                      icon: Icons.schedule,
                      color:
                          const Color(0xFFA9C7F2),
                      title: '타이밍 조절하기',
                      desc:
                          '상대가 여유로운 순간을 기다리는 것이 좋아요.',
                    ),

                    const SizedBox(height: 18),

                    _strategyCard(
                      icon:
                          Icons.chat_bubble_outline,
                      color:
                          const Color(0xFFB8A8E6),
                      title: '대화 빈도 늘리기',
                      desc:
                          '조금 더 자연스럽게 대화를 이어가보세요.',
                    ),
                  ],
                ),

              const SizedBox(height: 40),

              /// 성공률 상승 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(30),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF4A6480),
                      size: 32,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      '현재 전략을 잘 반영하면\n성공 가능성이 '
                      '$currentRate% → $improvedRate%까지 상승할 수 있어요 🌙',

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 18,
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
      ),
    );
  }

  /// 전략 카드
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

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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

  /// 전략별 아이콘
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

  /// 전략별 색상
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