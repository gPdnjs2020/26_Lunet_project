import 'package:flutter/material.dart';
import 'history_detail.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {

    /// 임시 최근 기록 데이터
    final List<Map<String, dynamic>> historyList = [

      {
        "title": "회사 퇴사하기",
        "percent": 74,
        "date": "JUNE 02, 2026",
        "icon": Icons.work_outline,
        "color": const Color(0xFF7EA7FF),
        "category": "커리어",
      },

      {
        "title": "고백해도 괜찮을까",
        "percent": 61,
        "date": "MAY 28, 2026",
        "icon": Icons.favorite_outline,
        "color": const Color(0xFFFF8FB1),
        "category": "연애",
      },

      {
        "title": "혼자 여행 떠나기",
        "percent": 89,
        "date": "MAY 18, 2026",
        "icon": Icons.flight_takeoff_rounded,
        "color": const Color(0xFF9B8CFF),
        "category": "여행",
      },

      {
        "title": "대학원 진학 고민",
        "percent": 67,
        "date": "APRIL 11, 2026",
        "icon": Icons.school_outlined,
        "color": const Color(0xFF64C7B2),
        "category": "학업",
      },

      {
        "title": "새로운 도전 시작",
        "percent": 82,
        "date": "MARCH 25, 2026",
        "icon": Icons.auto_awesome,
        "color": const Color(0xFFFFC857),
        "category": "기타",
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
        ),

        child: Column(
          children: [

            const SizedBox(height: 10),

            /// 캐릭터
            Container(
              width: 170,
              height: 170,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.white.withOpacity(0.7),

                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(0xFF4A6480)
                            .withOpacity(0.08),

                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),

              child: Center(
                child: Image.asset(
                  'assets/images/character.png',
                  width: 140,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// 제목
            const Text(
              '그날의 선택',

              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A6480),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              '루넷이 함께 고민했던\n소중한 순간들이에요 ✨',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 35),

            /// 기록 카드 리스트
            ...historyList.map(
              (history) {

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 20,
                  ),

                  child: _historyCard(
                    context,

                    icon: history['icon'],
                    color: history['color'],

                    title:
                        history['title'],

                    percent:
                        history['percent']
                            .toString(),

                    date:
                        history['date'],

                    category:
                        history['category'],
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(
    BuildContext context, {

    required IconData icon,
    required Color color,
    required String title,
    required String percent,
    required String date,
    required String category,
  }) {

    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) =>
                const HistoryDetailPage(),
          ),
        );
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(32),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.03,
              ),

              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// 상단 아이콘 + 카테고리
            Row(
              children: [

                Container(
                  width: 54,
                  height: 54,

                  decoration: BoxDecoration(
                    color:
                        color.withOpacity(0.12),

                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),

                const Spacer(),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color:
                        color.withOpacity(0.12),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(
                    category,

                    style: TextStyle(
                      color: color,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            /// 날짜
            Text(
              date,

              style: const TextStyle(
                fontSize: 11,
                color: Colors.black45,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            /// 제목 + 퍼센트
            Row(
              children: [

                Expanded(
                  child: Text(
                    title,

                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFE8F3FF),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(
                    '$percent%',

                    style: const TextStyle(
                      color:
                          Color(0xFF4A6480),

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 하단 버튼
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              decoration: BoxDecoration(
                color:
                    const Color(0xFFF7F5F2),

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  Text(
                    '기록 자세히 보기',

                    style: TextStyle(
                      color:
                          Color(0xFF4A6480),

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color:
                        Color(0xFF4A6480),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}