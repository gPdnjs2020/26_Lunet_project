import 'package:flutter/material.dart';
import 'detail.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {

  /// ----------------------------------------------------------
  /// 고민 입력 컨트롤러
  /// ----------------------------------------------------------
  final TextEditingController situationController =
      TextEditingController();

  /// ----------------------------------------------------------
  /// 예시 고민 자동 입력 함수
  /// ----------------------------------------------------------
  void fillExample(String text) {
    situationController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// ----------------------------------------------------------
              /// 캐릭터
              /// ----------------------------------------------------------
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
                        color: const Color(
                          0xFF4A6480,
                        ).withOpacity(0.08),

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

              /// ----------------------------------------------------------
              /// 말풍선
              /// ----------------------------------------------------------
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

                    /// 고민 입력
                    TextField(
                      controller: situationController,
                      maxLines: 6,

                      decoration: InputDecoration(
                        hintText:
                            '예: 지금 고백해도 될까?\n소개팅 이후 연락이 애매해...',
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
                          colors: [
                            Color(0xFF486A8A),
                            Color(0xFFA9C7F2),
                          ],
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
                              const SnackBar(
                                content: Text(
                                  '고민을 입력해주세요 🌙',
                                ),
                              ),
                            );

                            return;
                          }

                          /// detail 페이지 이동
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                situation:
                                    situationController.text.trim(),
                              ),
                            ),
                          );
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
                  fillExample(
                    '지금 고백해도 괜찮을까?\n상대방도 나를 좋아하는 것 같긴 한데 확신이 없어.',
                  );
                },

                child: _exampleCard(
                  icon: Icons.favorite_border,
                  iconColor: const Color(0xFFE6A5AE),
                  title: '고백하기',
                  description:
                      '그 사람도 나를 좋아할까?\n타이밍을 물어보세요.',
                ),
              ),

              const SizedBox(height: 16),

              /// 이직하기
              GestureDetector(
                onTap: () {
                  fillExample(
                    '지금 회사에서 계속 버티는 게 맞을까?\n새로운 회사 제안이 왔는데 고민돼.',
                  );
                },

                child: _exampleCard(
                  icon: Icons.work_outline,
                  iconColor: const Color(0xFFB8A8E6),
                  title: '이직하기',
                  description:
                      '지금 옮기는 게 맞을까?\n커리어 성장을 분석해요.',
                ),
              ),

              const SizedBox(height: 16),

              /// 공부 vs 놀기
              GestureDetector(
                onTap: () {
                  fillExample(
                    '시험이 얼마 안 남았는데 너무 쉬고 싶어.\n지금 놀아도 괜찮을까?',
                  );
                },

                child: _exampleCard(
                  icon: Icons.school_outlined,
                  iconColor: const Color(0xFFA9C7F2),
                  title: '공부 vs 놀기',
                  description:
                      '당장 필요한 선택은 무엇인지\n가이드를 드려요.',
                ),
              ),

              const SizedBox(height: 30),
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

            child: Icon(
              icon,
              color: iconColor,
            ),
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