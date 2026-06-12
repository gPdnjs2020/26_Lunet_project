import 'package:flutter/material.dart';
import '../strategy/strategy.dart';

import 'package:intl/intl.dart';
import '../../model/history_model.dart';
import '../../services/history_service.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:saver_gallery/saver_gallery.dart';
import 'result_save.dart';

class ResultPage extends StatefulWidget {
  final String situation;
  final String relation;
  final double readiness;
  final String timing;
  final String questionType;

  /// AI 결과
  final Map<String, dynamic> aiResult;

  const ResultPage({
    super.key,
    required this.situation,
    required this.relation,
    required this.readiness,
    required this.timing,
    required this.aiResult,
    required this.questionType,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _saved = false;

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();

    if (!_saved) {
      _saved = true;
      saveToHistory();
    }
  }

  Future<void> saveResultImage() async {
    try {
      final controller = ScreenshotController();

      final image = await controller.captureFromLongWidget(
        ResultSaveWidget(
          situation: widget.situation,
          successPercent: widget.aiResult['success_rate'] ?? 50,
          profileTitle: widget.aiResult['profile_title'] ?? '',
          profileStyle: widget.aiResult['profile_style'] ?? '',
          advice: widget.aiResult['advice'] ?? '',
          positive: widget.aiResult['positive'] ?? '',
          warning: widget.aiResult['warning'] ?? '',
          lunaMessage: widget.aiResult['luna_message'] ?? '',
        ),
        context: context,
        pixelRatio: 3,
      );

      final result = await SaverGallery.saveImage(
        image,
        fileName: "lunet_${DateTime.now().millisecondsSinceEpoch}",
        skipIfExists: false,
      );

      print(result);
    } catch (e) {
      print(e);
    }
  }

  void saveToHistory() async {
    final history = HistoryModel(
      title: widget.situation.length > 20
          ? '${widget.situation.substring(0, 20)}...'
          : widget.situation,
      successRate: widget.aiResult['success_rate'] ?? 50,
      category: widget.aiResult['category'] ?? '기타',
      situation: widget.situation,
      date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),

      // ✨ [추가된 부분] 이제 우리가 골랐던 질문 유형("A or B", "추천" 등)이 정상적으로 함께 저장됩니다!
      questionType: widget.questionType,

      userResult: '',

      advice: widget.aiResult['advice'] ?? '',
      positive: widget.aiResult['positive'] ?? '',
      warning: widget.aiResult['warning'] ?? '',
      lunaMessage: widget.aiResult['luna_message'] ?? '',

      profileTitle: widget.aiResult['profile_title'] ?? '',

      profileStyle: widget.aiResult['profile_style'] ?? '',
    );

    await HistoryService.saveHistory(history);
  }

  @override
  Widget build(BuildContext context) {
    final String questionType = widget.questionType;

    /// AI 데이터
    final int successPercent = widget.aiResult['success_rate'] ?? 50;

    final double successRate = successPercent / 100;

    final String advice = widget.aiResult['advice'] ?? '조금 더 자신감을 가져보세요.';

    final String positive =
        widget.aiResult['positive'] ?? '긍정적인 분위기가 형성되고 있어요.';

    final String warning =
        widget.aiResult['warning'] ?? '조금 더 타이밍을 지켜보는 것도 좋아요.';

    final String lunaMessage =
        widget.aiResult['luna_message'] ?? '당신은 이미 충분히 멋진 사람이에요 💜';

    final String profileStyle = widget.aiResult['profile_style'] ?? '신중한 스타일';

    final String profileTitle =
        widget.aiResult['profile_title'] ?? '깊은 통찰의 분석가';

    String blueBoxTitle = '';
    String blueBoxContent = '';

    if (questionType == '할까 말까') {
      blueBoxTitle = profileTitle;
      blueBoxContent = profileStyle;
    } else if (questionType == 'A or B') {
      blueBoxTitle = '루나의 선택';

      blueBoxContent =
          widget.aiResult['recommended'] ??
          widget.aiResult['choice_a'] ??
          '선택지 A';
    } else if (questionType == '추천') {
      blueBoxTitle = '루나 추천';

      final List list = widget.aiResult['recommendations'] ?? [];

      blueBoxContent = list.isNotEmpty ? list.first.toString() : '추천 결과 없음';
    } else if (questionType == '고민 상담') {
      blueBoxTitle = '현재 감정 상태';

      blueBoxContent = widget.aiResult['emotion'] ?? '보통';
    }

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

        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Color(0xFF7E57C2)),
            tooltip: '결과 저장',
            onPressed: saveResultImage,
          ),
        ],
      ),

      body: Screenshot(
        controller: screenshotController,

        child: SafeArea(
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

                /// 메인 텍스트
                if (questionType == '할까 말까')
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

                if (questionType == 'A or B')
                  const Text(
                    '두 선택지를 비교해봤어요',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),

                if (questionType == '추천')
                  const Text(
                    '루나의 추천 결과예요',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),

                if (questionType == '고민 상담')
                  const Text(
                    '당신을 위한 맞춤 해답이에요',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),

                const SizedBox(height: 12),

                const Text(
                  '루넷이 당신의 상황과 감정을 분석해봤어요 ✨',
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 24),

                if (questionType == '할까 말까')
                  _successCard(successPercent, successRate, advice),

                if (questionType == 'A or B') _compareCard(),

                if (questionType == '추천') _recommendCard(),

                if (questionType == '고민 상담') _counselCard(),

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
                          builder: (_) => StrategyPage(
                            aiResult: widget.aiResult,
                            questionType: widget.questionType,
                          ),
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

  Widget _buildResultHeader() {
    if (widget.questionType == 'A or B') {
      return Column(
        children: [
          const Text('루나의 선택', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            widget.aiResult['recommended'] ?? '',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    if (widget.questionType == '추천') {
      final strategies = widget.aiResult['strategies'] ?? [];

      return Column(
        children: [
          const Text('루나의 추천', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            strategies.isNotEmpty ? strategies[0]['title'] : '추천 없음',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    if (widget.questionType == '고민 상담') {
      return Column(
        children: [
          const Text('현재 감정 상태', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            widget.aiResult['emotion'] ?? '보통',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _compareCard() {
    // ✨ [수정됨] 억지로 문장을 자르지 않고, AI가 추출해준 핵심 단어를 그대로 씁니다!
    String a = widget.aiResult['choice_a'] ?? 'A';
    String b = widget.aiResult['choice_b'] ?? 'B';

    String? recommended = widget.aiResult['recommended'];
    String advice = widget.aiResult['advice'] ?? '루나의 분석 결과를 확인해보세요!';

    return Container(
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
        children: [
          const Text(
            '루나의 선택 ⚖️',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
          const SizedBox(height: 24),

          // ✨ AI가 뽑아준 단어 (예: "여름" VS "겨울") 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  a.trim(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 22, // 단어가 잘 보이도록 크기 약간 키움
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  b.trim(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 22, // 단어가 잘 보이도록 크기 약간 키움
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ✨ AI의 실제 선택(단어)과 이유(advice)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  '👉 루나의 PICK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6480),
                  ),
                ),
                const SizedBox(height: 12),

                // 단어 하나로 딱 떨어지는 선택 결과 ("여름", "짜장" 등)
                Text(
                  recommended ?? '선택 완료',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2B2B),
                  ),
                ),
                const SizedBox(height: 16),

                // 그 선택을 한 구체적인 이유
                Text(
                  advice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
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

  Widget _recommendCard() {
    final List list = widget.aiResult['strategies'] ?? [];
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            '루나 추천 TOP 3',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          for (int i = 0; i < list.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ${list[i]["title"]}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    list[i]["description"],
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _counselCard() {
    // ✨ 감정 대신 AI가 준 '핵심 조언'을 메인으로 사용합니다.
    final String coreAdvice =
        widget.aiResult['core_advice'] ??
        widget.aiResult['advice'] ??
        '스스로를 믿고 한 걸음 나아가보세요.';

    return Container(
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
        children: [
          const Text(
            '💡 맞춤 해결책',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            coreAdvice,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2B2B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 고민 카드
  Widget _successCard(int successPercent, double successRate, String advice) {
    return Container(
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
              const Icon(Icons.chat_bubble_outline, color: Color(0xFF4A6480)),

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
            widget.situation,

            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _miniInfoCard('관계', widget.relation)),

              const SizedBox(width: 12),

              Expanded(child: _miniInfoCard('실행 시기', widget.timing)),
            ],
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
