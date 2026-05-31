import 'package:flutter/material.dart';
import '../strategy/strategy.dart';

import 'package:intl/intl.dart';
import '../../model/history_model.dart';
import '../../services/history_service.dart';

class ResultPage extends StatelessWidget {
  final String situation;
  final String relation;
  final double readiness;
  final String timing;

  /// AI 결과
  final Map<String, dynamic> aiResult;

  const ResultPage({
    super.key,
    required this.situation,
    required this.relation,
    required this.readiness,
    required this.timing,
    required this.aiResult,
  });

  void saveToHistory() async {
    final history = HistoryModel(
      title: situation.length > 20
          ? '${situation.substring(0, 20)}...'
          : situation,
      successRate: aiResult['success_rate'] ?? 50,
      category: aiResult['category'] ?? '기타',
      situation: situation,
      date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    );

    await HistoryService.saveHistory(history);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveToHistory();
    });

    /// AI 데이터
    final int successPercent = aiResult['success_rate'] ?? 50;

    final double successRate = successPercent / 100;

    final String advice = aiResult['advice'] ?? '조금 더 자신감을 가져보세요.';

    final String positive = aiResult['positive'] ?? '긍정적인 분위기가 형성되고 있어요.';

    final String warning = aiResult['warning'] ?? '조금 더 타이밍을 지켜보는 것도 좋아요.';

    final String lunaMessage =
        aiResult['luna_message'] ?? '당신은 이미 충분히 멋진 사람이에요 💜';

    final String profileStyle = aiResult['profile_style'] ?? '신중한 스타일';

    final String profileTitle = aiResult['profile_title'] ?? '깊은 통찰의 분석가';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.black),

          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          },
        ),
      ),

      body: SafeArea(
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
                  child: Image.asset('assets/images/character.png', width: 145),
                ),
              ),

              const SizedBox(height: 24),

              /// 메인 텍스트
              Text(
                '지금은 약 $successPercent%\n가능해 보여요!',
                textAlign: TextAlign.center,

                style: const TextStyle(
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

                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 24),

              /// 고민 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

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
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Color(0xFF4A6480),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          '당신의 고민',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A6480),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Text(
                      situation,

                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: _miniInfoCard('관계', relation)),

                        const SizedBox(width: 12),

                        Expanded(child: _miniInfoCard('실행 시기', timing)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 프로필 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF486A8A), Color(0xFFA9C7F2)],
                  ),

                  borderRadius: BorderRadius.circular(32),
                ),

                child: Column(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 34,
                    ),

                    const SizedBox(height: 18),

                    Text(
                      profileTitle,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        profileStyle,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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

                        Column(
                          children: [
                            Text(
                              '$successPercent%',

                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A6480),
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text(
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

                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF4A6480),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              advice,

                              style: const TextStyle(
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
                      content: positive,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _analysisCard(
                      title: '주의 요소',
                      icon: Icons.lightbulb,
                      color: const Color(0xFFA9C7F2),
                      content: warning,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// 루나 조언 카드
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
                        Icon(Icons.psychology_alt, color: Color(0xFF7E57C2)),

                        SizedBox(width: 10),

                        Text(
                          '루나의 조언',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7E57C2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Text(
                      lunaMessage,

                      style: const TextStyle(
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
                    side: const BorderSide(color: Color(0xFF4A6480), width: 2),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => StrategyPage(aiResult: aiResult),
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
                    colors: [Color(0xFF486A8A), Color(0xFFA9C7F2)],
                  ),
                ),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,

                    shadowColor: Colors.transparent,
                  ),

                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
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

                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 분석 카드
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

            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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

  /// 미니 카드
  Widget _miniInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F2),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        children: [
          Text(
            title,

            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
        ],
      ),
    );
  }
}
