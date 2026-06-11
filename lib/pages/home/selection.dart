import 'package:flutter/material.dart';
import 'detail.dart';
import 'loading.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SelectionPage extends StatefulWidget {
  final String location;
  final String weather;

  const SelectionPage({
    super.key,
    required this.location,
    required this.weather,
  });

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  /// ----------------------------------------------------------
  /// 고민 입력 컨트롤러
  /// ----------------------------------------------------------
  final TextEditingController situationController = TextEditingController();

  String _selectedCategory = '할까 말까';

  final List<String> _categories = ['할까 말까', 'A or B', '추천', '고민 상담'];

  /// ----------------------------------------------------------
  /// 예시 고민 자동 입력 함수
  /// ----------------------------------------------------------
  void fillExample(String text) {
    situationController.text = text;
  }

  /// 음성인식 기능

  late stt.SpeechToText speech;

  bool isListening = false;

  @override
  void initState() {
    super.initState();

    speech = stt.SpeechToText();
  }

  Future<void> startListening() async {
    bool available = await speech.initialize();

    if (available) {
      setState(() {
        isListening = true;
      });

      await speech.listen(
        onResult: (result) {
          setState(() {
            situationController.text = result.recognizedWords;
          });
        },

        listenOptions: stt.SpeechListenOptions(localeId: 'ko_KR'),
      );
    }
  }

  Future<void> stopListening() async {
    await speech.stop();

    setState(() {
      isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(backgroundColor: const Color(0xFFF7F5F2), elevation: 0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Align(
                alignment: Alignment.centerRight,

                child: Container(
                  width: 100,
                  height: 100,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.7),

                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A6480).withOpacity(0.08),

                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: Center(
                    child: Image.asset(
                      'assets/images/character.png',
                      width: 80,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9E9),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Text(
                  '요즘 어떤 고민이 있어?',
                  style: TextStyle(
                    color: Color(0xFFE49B9B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ----------------------------------------------------------
              /// 메인 텍스트
              /// ----------------------------------------------------------
              const Center(
                child: Text(
                  '너의 고민을\n털어놔봐',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Color(0xFF222222),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4A6480)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4A6480)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              /// ----------------------------------------------------------
              /// 입력 카드
              /// ----------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

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
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// 음성 입력 안내
                    Row(
                      children: [
                        const Text(
                          '음성으로 입력하기',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const Spacer(),

                        IconButton(
                          icon: Icon(
                            isListening ? Icons.mic : Icons.mic_none,
                            color: isListening ? Colors.red : Colors.blueGrey,
                          ),

                          onPressed: () {
                            if (isListening) {
                              stopListening();
                            } else {
                              startListening();
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// 고민 입력
                    TextField(
                      controller: situationController,
                      maxLines: 6,

                      decoration: InputDecoration(
                        hintText: '예: 지금 고백해도 될까?\n소개팅 이후 연락이 애매해...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// AI 안내
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Colors.blueGrey.shade300,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          'AI 루나가 당신의 상황을 분석합니다',
                          style: TextStyle(
                            color: Colors.blueGrey.shade300,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ----------------------------------------------------------
                    /// 분석 시작 버튼
                    /// ----------------------------------------------------------
                    Container(
                      width: double.infinity,
                      height: 60,

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
                          /// 입력값 없을 때
                          if (situationController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('고민을 입력해주세요 🌙')),
                            );
                            return;
                          }

                          // ✨ [UX 개선 포인트] 'A or B'나 '추천'은 디테일 설정 없이 바로 로딩 화면으로 이동!
                          if (_selectedCategory == 'A or B' ||
                              _selectedCategory == '추천') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoadingPage(
                                  situation: situationController.text.trim(),
                                  questionType: _selectedCategory,
                                  location: widget.location,
                                  weather: widget.weather,

                                  // 💡 디테일 페이지를 건너뛰므로, LoadingPage가 요구하는
                                  // 나머지 필수 변수들은 기본값(더미 데이터)으로 채워서 넘겨줍니다.
                                  relation: '기본값',
                                  readiness: 50.0,
                                  timing: '지금 당장',
                                ),
                              ),
                            );
                          } else {
                            /// '할까 말까', '고민 상담'은 기존대로 detail 페이지로 이동하여 세부 설정 진행
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(
                                  situation: situationController.text.trim(),
                                  questionType: _selectedCategory,
                                  location: widget.location,
                                  weather: widget.weather,
                                ),
                              ),
                            );
                          }
                        },

                        child: const Text(
                          '우리 같이 알아봐!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ----------------------------------------------------------
              /// 추천 고민
              /// ----------------------------------------------------------
              const Text(
                '이런 고민은 어때요? ✨',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF555555),
                ),
              ),

              const SizedBox(height: 16),

              /// 고백하기
              GestureDetector(
                onTap: () {
                  fillExample('지금 고백해도 괜찮을까?\n상대방도 나를 좋아하는 것 같긴 한데 확신이 없어.');
                  // ⭐ '할까 말까' 카테고리 자동 선택
                  setState(() {
                    _selectedCategory = '할까 말까';
                  });
                },
                child: _exampleCard(
                  icon: Icons.favorite_border,
                  iconColor: const Color(0xFFE6A5AE),
                  title: '고백하기',
                  description: '그 사람도 나를 좋아할까?\n타이밍을 물어보세요.',
                ),
              ),

              const SizedBox(height: 16),

              /// ⭐ [신규 추가] 여름 VS 겨울
              GestureDetector(
                onTap: () {
                  fillExample('여름? 겨울? 둘 중 어느 계절이 좋아?');
                  // ⭐ 'A or B' 카테고리 자동 선택
                  setState(() {
                    _selectedCategory = 'A or B';
                  });
                },
                child: _exampleCard(
                  icon: Icons.ac_unit_outlined, // ❄️ 눈꽃 아이콘 적용
                  iconColor: const Color(0xFF90D8D8), // 상쾌한 민트 계열 색상
                  title: '여름 VS 겨울',
                  description: '짜장 vs 짬뽕처럼\n둘 중 하나를 고르기 힘들 때!',
                ),
              ),

              const SizedBox(height: 16),

              /// 이직하기
              GestureDetector(
                onTap: () {
                  fillExample('지금 회사에서 계속 버티는 게 맞을까?\n새로운 회사 제안이 왔는데 고민돼.');
                  // ⭐ '추천' 카테고리 자동 선택
                  setState(() {
                    _selectedCategory = '추천';
                  });
                },
                child: _exampleCard(
                  icon: Icons.work_outline,
                  iconColor: const Color(0xFFB8A8E6),
                  title: '이직하기',
                  description: '지금 옮기는 게 맞을까?\n커리어 성장을 분석해요.',
                ),
              ),

              const SizedBox(height: 16),

              /// 공부 vs 놀기
              GestureDetector(
                onTap: () {
                  fillExample('시험이 얼마 안 남았는데 너무 쉬고 싶어.\n지금 놀아도 괜찮을까?');
                  // ⭐ '고민 상담' 카테고리 자동 선택
                  setState(() {
                    _selectedCategory = '고민 상담';
                  });
                },
                child: _exampleCard(
                  icon: Icons.school_outlined,
                  iconColor: const Color(0xFFA9C7F2),
                  title: '공부 vs 놀기',
                  description: '당장 필요한 선택은 무엇인지\n가이드를 드려요.',
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// 예시 카드 위젯
  /// ----------------------------------------------------------
  Widget _exampleCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
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
        children: [
          /// 아이콘
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(width: 18),

          /// 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,

                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
