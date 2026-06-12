import 'package:flutter/material.dart';
import '../../model/history_model.dart';
import '../../services/history_service.dart';
import 'history_detail.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryModel> histories = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final result = await HistoryService.loadHistories();

    setState(() {
      histories = result;
    });
  }

  String getEmoji(String questionType) {
    if (questionType.contains("할까")) return '🔮'; // 할까 말까 (수정 구슬)
    if (questionType.contains("A or B")) return '⚖️'; // A or B (저울)
    if (questionType.contains("추천")) return '💡'; // 추천 (전구/아이디어)
    if (questionType.contains("상담")) return '💬'; // 고민 상담 (말풍선/대화)

    return '✨'; // 기본
  }

  Color getColor(String questionType) {
    if (questionType.contains("할까")) return const Color(0xFF9B8CFF); // 은은한 보라색
    if (questionType.contains("A or B"))
      return const Color(0xFF7EA7FF); // 부드러운 파란색
    if (questionType.contains("추천")) return const Color(0xFFFFC857); // 따뜻한 노란색
    if (questionType.contains("상담")) return const Color(0xFFFF8FB1); // 포근한 핑크색

    return const Color(0xFFB0BEC5); // 기본 회색
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            Container(
              width: 170,
              height: 170,
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
                child: Image.asset('assets/images/character.png', width: 140),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              '그날의 선택',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A6480),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              '루나와 함께 고민했던\n소중한 순간들이에요 ✨',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 35),

            if (histories.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  '아직 저장된 기록이 없어요 💜',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),

            ...histories.asMap().entries.map((entry) {
              final index = entry.key;
              final history = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _historyCard(
                  context,
                  // ✨ [수정 됨] category 대신 questionType을 넘겨줍니다!
                  emoji: getEmoji(history.questionType),
                  color: getColor(history.questionType),

                  title: history.title,
                  percent: history.successRate.toString(),
                  date: history.date,
                  category: history.category, // 여기는 그대로 둡니다.
                  history: history,
                  index: index,
                ),
              );
            }).toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(
    BuildContext context, {
    required String emoji,
    required Color color,
    required String title,
    required String percent,
    required String date,
    required String category,
    required HistoryModel history,
    required int index,
  }) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailPage(history: history, index: index),
          ),
        );
        await loadHistory();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
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
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24), // 이모티콘 크기
                    ),
                  ),
                ),
                const Spacer(),

                // ✨ 우상단 회색 박스 (할까말까, 추천, A or B가 들어갑니다!)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    history.questionType, // 👈 데이터가 무조건 들어갑니다.
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              date,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title, // 메인 주제 큰 글씨
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ✨ [수정] 오직 '할까 말까'일 때만 % 박스를 보여줍니다! (띄어쓰기 유무 모두 허용)
                if (history.questionType == '할까 말까' ||
                    history.questionType == '할까말까')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$percent%'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
