import 'package:flutter/material.dart';

class StrategyPage extends StatelessWidget {
  final Map<String, dynamic> aiResult;
  final String questionType;

  const StrategyPage({
    super.key,
    required this.aiResult,
    required this.questionType,
  });

  @override
  Widget build(BuildContext context) {
    final List strategies = aiResult['strategies'] ?? [];

    // ✨ 질문 유형에 따라 상단 제목과 부제목을 똑똑하게 바꿔줍니다!
    String headerTitle = '';
    String headerSub = '';

    if (questionType == '할까 말까') {
      headerTitle = '성공 확률 높이기 📈';
      headerSub = '이렇게 행동해보면 훨씬 더 좋은 결과가 있을 거예요.';
    } else if (questionType == 'A or B') {
      headerTitle = '이 선택의 근거 ⚖️';
      headerSub = '루나가 이 선택지를 강력하게 추천하는 이유예요.';
    } else if (questionType == '추천') {
      headerTitle = '더 나은 차선책 💡';
      headerSub = '이런 방안들은 어때요? 선택지를 넓혀 드릴게요.';
    } else {
      // 고민 상담 등
      headerTitle = '나아질 수 있는 방향 🌱';
      headerSub = '상황은 충분히 좋아질 수 있어요. 이렇게 마음을 다잡아 보세요.';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // ✨ 변경된 제목 표시
              Text(
                headerTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),
              const SizedBox(height: 8),
              // ✨ 변경된 부제목 표시
              Text(
                headerSub,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // 전략(또는 근거/차선책) 리스트 출력
              if (strategies.isEmpty)
                const Center(
                  child: Text(
                    '결과를 불러올 수 없습니다.',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              else
                ...strategies.map((strategy) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✨ % 뱃지가 완전히 삭제되고, 제목과 내용만 깔끔하게 나옵니다.
                        Text(
                          strategy['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2B2B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          strategy['description'] ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
