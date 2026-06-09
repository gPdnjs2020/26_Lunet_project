import 'package:flutter/material.dart';
import '../strategy/strategy.dart';

import 'package:intl/intl.dart';
import '../../model/history_model.dart';
import '../../services/history_service.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:saver_gallery/saver_gallery.dart';
import 'result_save.dart';

// ⭐ 새로 만든 분리된 카드 위젯들을 불러옵니다.
import 'result_cards.dart';

class ResultPage extends StatefulWidget {
  final String situation;
  final String relation;
  final double readiness;
  final String timing;
  final String questionType;
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
    final String qType = widget.questionType.replaceAll(' ', '');

    final int successPercent = widget.aiResult['success_rate'] ?? 50;
    final String positive =
        widget.aiResult['positive'] ?? '긍정적인 분위기가 형성되고 있어요.';
    final String warning =
        widget.aiResult['warning'] ?? '조금 더 타이밍을 지켜보는 것도 좋아요.';
    final String lunaMessage =
        widget.aiResult['luna_message'] ?? '당신은 이미 충분히 멋진 사람이에요 💜';

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

                /// 메인 텍스트 분기 처리
                if (qType == '할까말까')
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

                if (qType == 'AorB')
                  Text(
                    '루나의 선택은\n[ ${widget.aiResult['recommended'] ?? widget.aiResult['choice_a'] ?? '선택지'} ]!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),

                if (qType == '추천')
                  Column(
                    children: [
                      const Text(
                        '루나 추천 TOP 3',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...(widget.aiResult['strategies'] as List? ?? [])
                          .take(3)
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '✨ ${item["title"]}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6480),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),

                if (qType != '고민상담') ...[
                  const SizedBox(height: 16),
                  const Text(
                    '루넷이 당신의 상황과 감정을 분석해봤어요 ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],

                const SizedBox(height: 24),

                /// ⭐ 외부 파일(result_cards.dart)에서 깔끔하게 위젯을 불러옵니다.
                if (qType == '할까말까')
                  SuccessCard(
                    situation: widget.situation,
                    relation: widget.relation,
                    timing: widget.timing,
                  ),

                if (qType == 'AorB') CompareCard(aiResult: widget.aiResult),

                if (qType == '추천') RecommendCard(aiResult: widget.aiResult),

                if (qType == '고민상담') CounselCard(aiResult: widget.aiResult),

                const SizedBox(height: 24),

                /// 긍정/주의 분석 카드
                Row(
                  children: [
                    Expanded(
                      child: AnalysisCard(
                        title: '긍정 요소',
                        icon: Icons.favorite,
                        color: const Color(0xFFE9A5AF),
                        content: positive,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AnalysisCard(
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
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
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
}
