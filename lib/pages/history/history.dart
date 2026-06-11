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

  // 👇 기존 getIcon 함수를 지우고 이 코드로 덮어써주세요!
  String getEmoji(String category) {
    switch (category) {
      // 💖 사랑 & 사람
      case "연애":
        return '❤️';
      case "친구":
      case "인간관계":
        return '🤝';
      case "가족":
        return '👨‍👩‍👧';

      // 💼 일 & 성장
      case "회사":
      case "이직":
        return '💼';
      case "공부":
        return '📚';
      case "진로":
      case "취업":
        return '🚀';

      // 💰 현실 & 생활
      case "돈":
      case "재테크":
        return '💰';
      case "쇼핑":
      case "구매":
        return '🛍️';
      case "음식":
      case "메뉴":
        return '🍽️'; // 짜장 vs 짬뽕 같은 고민
      case "건강":
      case "다이어트":
        return '🏃‍♀️';
      case "이사":
        return '🏠';

      // 🎨 여가 & 기타
      case "여행":
        return '✈️';
      case "취미":
        return '🎨';
      case "반려동물":
        return '🐾';
      case "멘탈":
      case "심리":
        return '🧠';

      default:
        return '✨'; // 지정되지 않은 나머지 모든 카테고리
    }
  }

  Color getColor(String category) {
    switch (category) {
      // 💖 따뜻한 핑크/피치 계열 (사랑, 관계)
      case "연애":
        return const Color(0xFFFF8FB1);
      case "친구":
      case "인간관계":
        return const Color(0xFFFFA07A); // 라이트 살몬
      case "가족":
        return const Color(0xFF9B8CFF);

      // 💼 차분한 블루/네이비 계열 (일, 진로)
      case "회사":
      case "이직":
        return const Color(0xFF7EA7FF);
      case "공부":
        return const Color(0xFF64C7B2);
      case "진로":
      case "취업":
        return const Color(0xFF4A6480);

      // 💰 활기찬 옐로우/그린 계열 (현실, 돈, 음식)
      case "돈":
      case "재물":
        return const Color(0xFFFFC857);
      case "음식":
      case "메뉴":
        return const Color(0xFFFFB347); // 피치 오렌지
      case "건강":
      case "다이어트":
        return const Color(0xFF81C784); // 산뜻한 그린

      // 🎨 톡톡 튀는 포인트 컬러 (쇼핑, 여가)
      case "쇼핑":
      case "구매":
        return const Color(0xFFFF6B6B); // 코랄 레드
      case "여행":
        return const Color(0xFF4DD0E1); // 스카이 블루
      case "취미":
        return const Color(0xFFBA68C8); // 퍼플
      case "반려동물":
        return const Color(0xFFA1887F); // 브라운
      case "멘탈":
      case "심리":
        return const Color(0xFF90CAF9);

      default:
        return const Color(0xFFB0BEC5); // 기타 기본 색상 (부드러운 회색/은색)
    }
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
                  emoji: getEmoji(history.category),
                  color: getColor(history.category),
                  title: history.title,
                  percent: history.successRate.toString(),
                  date: history.date,
                  category: history.category,
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

                // ✨ 'A or B'나 '추천'이 아닐 때만 % 박스 노출!
                if (history.questionType != 'A or B' &&
                    history.questionType != '추천')
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
