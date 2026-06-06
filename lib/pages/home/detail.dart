import 'package:flutter/material.dart';
import 'loading.dart';


class DetailPage extends StatefulWidget {

  /// selection 페이지에서 전달받은 고민 내용
  final String situation;
  final String questionType;

  const DetailPage({
    super.key,
    required this.situation,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int selectedRelation = 0;
  int selectedTiming = 0;

  double readiness = 0.5;

  final List<String> relations = [
    '나 자신 🙋',
    '가족 👨‍👩‍👧',
    '친구/연인 ❤️',
    '직장 동료 💼',
    '기타',
  ];

  final List<Map<String, String>> timings = [
    {
      'title': '지금 바로',
      'desc': '더 이상 지체할 수 없어요.',
    },

    {
      'title': '이번 주 내로',
      'desc': '충분히 고민해보고 결정할게요.',
    },

    {
      'title': '나중에 천천히',
      'desc': '아직은 서두르고 싶지 않아요.',
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      /// ----------------------------------------------------------
      /// AppBar
      /// ----------------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Detail',
          style: TextStyle(
            color: Color(0xFF4A6480),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ----------------------------------------------------------
      /// Body
      /// ----------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// ----------------------------------------------------------
              /// 말풍선
              /// ----------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Image.asset(
                    'assets/images/character.png',
                    width: 55,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: const Color(0xFFE9D8FF),
                        borderRadius: BorderRadius.circular(28),
                      ),

                      child: const Text(
                        '거의 다 왔어요!\n당신의 상황에 대해 조금 더 자세히 알려주시겠어요? ✨',

                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ----------------------------------------------------------
              /// 사용자가 입력한 고민
              /// ----------------------------------------------------------
              const Text(
                '당신의 고민',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Text(
                  widget.situation,

                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              /// ----------------------------------------------------------
              /// 누구와 관련?
              /// ----------------------------------------------------------
              const Text(
                '누구와 관련된 선택인가요?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 12,
                runSpacing: 12,

                children: List.generate(
                  relations.length,

                  (index) => _relationChip(
                    text: relations[index],
                    isSelected: selectedRelation == index,

                    onTap: () {
                      setState(() {
                        selectedRelation = index;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// ----------------------------------------------------------
              /// 준비 정도 카드
              /// ----------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFFF2EFE9),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      '얼마나 준비됐다고 생각해?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A6480),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '마음의 준비 정도를 알려주세요.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor:
                            const Color(0xFF4A6480),

                        inactiveTrackColor:
                            Colors.blueGrey.shade100,

                        thumbColor:
                            const Color(0xFF4A6480),

                        overlayColor:
                            const Color(0xFF4A6480)
                                .withOpacity(0.2),

                        trackHeight: 6,
                      ),

                      child: Slider(
                        value: readiness,

                        onChanged: (value) {
                          setState(() {
                            readiness = value;
                          });
                        },
                      ),
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: const [

                        Column(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 4),

                            Text(
                              '초기 구상',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            Icon(
                              Icons.rocket_launch,
                              color: Color(0xFF4A6480),
                            ),

                            SizedBox(height: 4),

                            Text(
                              '실행 직전',
                              style: TextStyle(
                                color: Color(0xFF4A6480),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ----------------------------------------------------------
              /// 언제 실행?
              /// ----------------------------------------------------------
              const Text(
                '언제 실행하실 건가요?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: List.generate(
                  timings.length,

                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),

                    child: _timingCard(
                      title: timings[index]['title']!,
                      desc: timings[index]['desc']!,
                      selected:
                          selectedTiming == index,

                      onTap: () {
                        setState(() {
                          selectedTiming = index;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// ----------------------------------------------------------
              /// 분석 버튼
              /// ----------------------------------------------------------
              Container(
                width: double.infinity,
                height: 65,

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
                        builder: (_) => LoadingPage(
                          situation: widget.situation,
                          relation:
                              relations[selectedRelation],
                          readiness: readiness,
                          timing: timings[selectedTiming]
                              ['title']!,
                        ),
                      ),
                    );
                  },

                  child: const Text(
                    '분석 시작하기 ✨',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  '"당신의 최선의 결정을 루나가 함께 응원할게요." 💞',

                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// 관계 선택 칩
  /// ----------------------------------------------------------
  Widget _relationChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEAF2FF)
              : Colors.white,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: isSelected
                ? const Color(0xFF8EB5E8)
                : Colors.transparent,

            width: 2,
          ),
        ),

        child: Text(
          text,

          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,

            color: const Color(0xFF4A6480),
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// 타이밍 카드
  /// ----------------------------------------------------------
  Widget _timingCard({
    required String title,
    required String desc,
    required bool selected,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        width: double.infinity,
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),

          border: Border.all(
            color: selected
                ? const Color(0xFF8EB5E8)
                : Colors.transparent,

            width: 2,
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 54,
              height: 54,

              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEAF2FF)
                    : Colors.grey.shade100,

                shape: BoxShape.circle,
              ),

              child: Icon(
                selected
                    ? Icons.check
                    : Icons.schedule,

                color: const Color(0xFF4A6480),
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

                  const SizedBox(height: 6),

                  Text(
                    desc,

                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}