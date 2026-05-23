import 'dart:async';
import 'package:flutter/material.dart';
import 'result.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

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
    '루넷이 당신을 위해 고민 중이에요...',
  ];

  int currentText = 0;

  @override
  void initState() {
    super.initState();

    /// 둥둥 애니메이션
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    /// 로딩 문구 변경
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        currentText = (currentText + 1) % loadingTexts.length;
      });
    });

    /// 결과 페이지 이동
    Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

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

              const Spacer(),

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
                '루넷이\n당신의 고민을 분석 중이에요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  color: Color(0xFF2B2B2B),
                ),
              ),

              const SizedBox(height: 22),

              /// 서브 텍스트
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

              /// 프로그레스
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      minHeight: 10,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF4A6480),
                      ),
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

              const Spacer(),

              /// 하단 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Column(
                  children: [
                    Icon(Icons.auto_awesome, color: Color(0xFF4A6480)),

                    SizedBox(height: 12),

                    Text(
                      '당신의 감정, 상황, 타이밍을\n종합적으로 분석하고 있어요 ✨',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.6,
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
}
