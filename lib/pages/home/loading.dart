import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/ai_service.dart';
import 'result.dart';

class LoadingPage extends StatefulWidget {
  final String situation;
  final String relation;
  final double readiness;
  final String timing;
  final String questionType;

  const LoadingPage({
    super.key,
    required this.situation,
    required this.relation,
    required this.readiness,
    required this.timing,
    required this.questionType,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatingAnimation;

  final List<String> loadingTexts = [
    '비슷한 상황들을 찾고 있어요...',
    '감정 패턴을 분석하는 중...',
    '최적의 선택지를 계산하고 있어요...',
    '루나가 당신을 위해 고민 중이에요...',
  ];

  int currentText = 0;

  Timer? textTimer;

  @override
  void initState() {
    super.initState();

    /// 캐릭터 애니메이션
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    /// 로딩 텍스트 변경
    textTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        currentText = (currentText + 1) % loadingTexts.length;
      });
    });

    /// AI 분석 시작
    _analyzeWithAI();
  }

  Future<void> _analyzeWithAI() async {
    try {
      final aiResult = await AiService.analyzeDecision(
        target: widget.relation,
        readiness: widget.readiness * 100,
        timing: widget.timing,
        situation: widget.situation,
        questionType: widget.questionType,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            situation: widget.situation,
            relation: widget.relation,
            readiness: widget.readiness,
            timing: widget.timing,
            aiResult: aiResult,
            questionType: widget.questionType,
          ),
        ),
      );
    } catch (e) {
      debugPrint('AI 오류: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('AI 분석 중 오류가 발생했어요 😢')));
    }
  }

  @override
  void dispose() {
    textTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 40,
            ),

            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// 상단 로고
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        'Lunet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6480),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// 캐릭터 애니메이션
                  AnimatedBuilder(
                    animation: _floatingAnimation,

                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: child,
                      );
                    },

                    child: Container(
                      width: 220,
                      height: 220,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),

                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A6480).withOpacity(0.08),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),

                      child: Center(
                        child: Image.asset(
                          'assets/images/character.png',
                          width: 180,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 45),

                  /// 메인 텍스트
                  const Text(
                    '루나가\n당신의 고민을 분석 중이에요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// 변경되는 로딩 텍스트
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),

                    child: Text(
                      loadingTexts[currentText],
                      key: ValueKey(currentText),

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 프로그레스 바
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: const LinearProgressIndicator(
                          minHeight: 10,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF4A6480)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        '잠시만 기다려주세요...',
                        style: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// 하단 정보 카드
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF4A6480),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          '당신의 감정, 상황, 타이밍을\n종합적으로 분석하고 있어요 ✨',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// 사용자 입력 정보
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F5F2),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                '고민 내용',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                widget.situation,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _miniInfoCard('관계', widget.relation),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: _miniInfoCard('타이밍', widget.timing),
                                  ),
                                ],
                              ),
                            ],
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
        ),
      ),
    );
  }

  Widget _miniInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            softWrap: true,
            overflow: TextOverflow.visible,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
        ],
      ),
    );
  }
}
