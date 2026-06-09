import 'package:flutter/material.dart';

/// 1. 긍정/주의 요소 분석 카드
class AnalysisCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  const AnalysisCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. A or B 비교 카드
class CompareCard extends StatelessWidget {
  final Map<String, dynamic> aiResult;

  const CompareCard({super.key, required this.aiResult});

  @override
  Widget build(BuildContext context) {
    final a = aiResult['choice_a'] ?? '선택지 A';
    final b = aiResult['choice_b'] ?? '선택지 B';
    final recommended = aiResult['recommended'] ?? a;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const Text(
            '루나의 추천',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            a,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('VS', style: TextStyle(fontSize: 22, color: Colors.grey)),
          const SizedBox(height: 12),
          Text(
            b,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            '👉 $recommended',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. 추천 전략 TOP 3 카드
class RecommendCard extends StatelessWidget {
  final Map<String, dynamic> aiResult;

  const RecommendCard({super.key, required this.aiResult});

  @override
  Widget build(BuildContext context) {
    final List list = aiResult['strategies'] ?? [];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '상세 추천 전략',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < list.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ${list[i]["title"]}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    list[i]["description"],
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 4. 감정 분석 카드
class CounselCard extends StatelessWidget {
  final Map<String, dynamic> aiResult;

  const CounselCard({super.key, required this.aiResult});

  @override
  Widget build(BuildContext context) {
    final emotion = aiResult['emotion'] ?? '보통';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const Text(
            '현재 감정 상태',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            emotion,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
        ],
      ),
    );
  }
}

/// 5. 고민 상황 요약 카드
class SuccessCard extends StatelessWidget {
  final String situation;
  final String relation;
  final String timing;

  const SuccessCard({
    super.key,
    required this.situation,
    required this.relation,
    required this.timing,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: Color(0xFF4A6480)),
              SizedBox(width: 10),
              Text(
                '당신의 고민',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6480),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            situation,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MiniInfoCard(title: '관계', value: relation),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniInfoCard(title: '실행 시기', value: timing),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 6. 미니 카드 (SuccessCard 내부에서 사용)
class _MiniInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _MiniInfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6480),
            ),
          ),
        ],
      ),
    );
  }
}
