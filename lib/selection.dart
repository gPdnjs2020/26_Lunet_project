import 'package:flutter/material.dart';
import 'detail.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),

                /// 상단 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundImage:
                          AssetImage('assets/images/logo.png'),
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

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 캐릭터
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/character.png',
                    width: 90,
                  ),
                ),

                const SizedBox(height: 10),

                /// 말풍선
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
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

                /// 메인텍스트
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

                const SizedBox(height: 30),

                /// 입력 카드
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

                      TextField(
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: '예: 지금 고백해도 될까?',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [

                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: Colors.blueGrey.shade300,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            'AI가 당신의 상황을 분석합니다',
                            style: TextStyle(
                              color: Colors.blueGrey.shade300,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 버튼
                      Container(
                        width: double.infinity,
                        height: 58,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DetailPage(),
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

                const SizedBox(height: 35),

                /// 추천 고민
                const Text(
                  '이런 고민은 어때요? ✨',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555),
                  ),
                ),

                const SizedBox(height: 20),

                _exampleCard(
                  icon: Icons.favorite_border,
                  iconColor: Color(0xFFE6A5AE),
                  title: '고백하기',
                  description:
                  '그 사람도 나를 좋아할까?\n타이밍을 물어보세요.',
                ),

                const SizedBox(height: 18),

                _exampleCard(
                  icon: Icons.work_outline,
                  iconColor: Color(0xFFB8A8E6),
                  title: '이직하기',
                  description:
                  '지금 옮기는 게 맞을까?\n커리어 성장을 분석해요.',
                ),

                const SizedBox(height: 18),

                _exampleCard(
                  icon: Icons.school_outlined,
                  iconColor: Color(0xFFA9C7F2),
                  title: '공부 vs 놀기',
                  description:
                  '당장 필요한 선택은 무엇인지\n가이드를 드려요.',
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
      ),

      child: Row(
        children: [

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