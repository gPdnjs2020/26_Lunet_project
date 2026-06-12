import 'package:flutter/material.dart';
import '../../model/history_model.dart';
import '../../services/history_service.dart';

class HistoryDetailPage extends StatefulWidget {
  final HistoryModel history;
  final int index;

  const HistoryDetailPage({
    super.key,
    required this.history,
    required this.index,
  });

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  bool isSuccessSelected = false;
  bool isFailSelected = false;

  void selectSuccess() async {
    setState(() {
      isSuccessSelected = true;
      isFailSelected = false;
    });

    final updated = HistoryModel(
      title: widget.history.title,
      successRate: widget.history.successRate,
      category: widget.history.category,
      situation: widget.history.situation,
      date: widget.history.date,

      // ✨ [아주 중요] 이거 안 넣으면 성공 버튼 누를 때마다 우상단 박스 글자가 사라집니다!!
      questionType: widget.history.questionType,

      advice: widget.history.advice,
      positive: widget.history.positive,
      warning: widget.history.warning,
      lunaMessage: widget.history.lunaMessage,
      profileTitle: widget.history.profileTitle,
      profileStyle: widget.history.profileStyle,
      userResult: 'success',
    );

    await HistoryService.updateHistory(widget.index, updated);
  }

  void selectFail() async {
    setState(() {
      isSuccessSelected = false;
      isFailSelected = true;
    });

    final updated = HistoryModel(
      title: widget.history.title,
      successRate: widget.history.successRate,
      category: widget.history.category,
      situation: widget.history.situation,
      date: widget.history.date,

      questionType: widget.history.questionType,

      advice: widget.history.advice,
      positive: widget.history.positive,
      warning: widget.history.warning,
      lunaMessage: widget.history.lunaMessage,

      profileTitle: widget.history.profileTitle,
      profileStyle: widget.history.profileStyle,

      userResult: 'fail',
    );

    await HistoryService.updateHistory(widget.index, updated);
  }

  @override
  void initState() {
    super.initState();

    if (widget.history.userResult == 'success') {
      isSuccessSelected = true;
    }

    if (widget.history.userResult == 'fail') {
      isFailSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = widget.history;
    final index = widget.index;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await HistoryService.deleteHistoryByIndex(index);

              if (context.mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('기록이 삭제되었습니다')));
              }
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: SingleChildScrollView(
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

                const SizedBox(height: 32),

                /// 말풍선
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9D8FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '그때 나눴던 고민의 결과가 궁금해!\n루나가 기다리고 있었어요 ✨', // ✨ 어떤 고민이든 자연스럽도록 문구 수정
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// ORIGINAL RESULT
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MY QUESTION TYPE', // ✨ 주제 대신 질문 유형이라는 느낌을 줍니다.
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        history.questionType, // 카테고리명 고정
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // ✨ [수정] 여기도 오직 '할까 말까'일 때만 % 텍스트를 보여줍니다!
                      if (history.questionType == '할까 말까' ||
                          history.questionType == '할까말까') ...[
                        const SizedBox(height: 8),
                        Text(
                          '${history.successRate}%',
                          style: const TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A6480),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      Text(
                        history.date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// 고민 내용 (ResultPage 그대로)
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '고민 내용',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        history.situation,
                        style: const TextStyle(fontSize: 15, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI 조언',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(history.advice),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '긍정 요소',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(history.positive),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '주의 요소',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(history.warning),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '루나의 조언',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(history.lunaMessage),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  '실제로 어떻게 되었나요?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                /// 성공 / 실패 선택
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: selectSuccess,
                        child: _resultCard(
                          emoji: '❤️',
                          title: '성공했어요!',
                          selected: isSuccessSelected,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: selectFail,
                        child: _resultCard(
                          emoji: '🥲',
                          title: '아쉬워요..',
                          selected: isFailSelected,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 공통 카드
  Widget _card({required Widget child}) {
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
      child: child,
    );
  }

  /// 성공/실패 카드 (눌림 효과)
  Widget _resultCard({
    required String emoji,
    required String title,
    required bool selected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 32),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(selected ? 0.12 : 0.03),
            blurRadius: selected ? 22 : 12,
            offset: const Offset(0, 4),
          ),
        ],

        border: Border.all(
          color: selected ? const Color(0xFF4A6480) : Colors.transparent,
          width: 2,
        ),
      ),

      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 42)),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: selected ? const Color(0xFF4A6480) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
