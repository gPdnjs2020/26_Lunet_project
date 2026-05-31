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

  IconData getIcon(String category) {
    switch (category) {
      case "연애":
        return Icons.favorite_outline;
      case "회사":
        return Icons.work_outline;
      case "공부":
        return Icons.school_outlined;
      case "진로":
        return Icons.trending_up;
      case "가족":
        return Icons.home_outlined;
      default:
        return Icons.auto_awesome;
    }
  }

  Color getColor(String category) {
    switch (category) {
      case "연애":
        return const Color(0xFFFF8FB1);
      case "회사":
        return const Color(0xFF7EA7FF);
      case "공부":
        return const Color(0xFF64C7B2);
      case "진로":
        return const Color(0xFFFFC857);
      case "가족":
        return const Color(0xFF9B8CFF);
      default:
        return const Color(0xFF4A6480);
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
              '루넷이 함께 고민했던\n소중한 순간들이에요 ✨',
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
                  icon: getIcon(history.category),
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
    required IconData icon,
    required Color color,
    required String title,
    required String percent,
    required String date,
    required String category,
    required HistoryModel history,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailPage(history: history, index: index),
          ),
        );
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
                  child: Icon(icon, color: color),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
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
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
