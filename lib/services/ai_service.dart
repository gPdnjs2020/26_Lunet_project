import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {

  static const String apiKey =
      'AQ.Ab8RN6LDyO7_794tpwpfzfs5G5IefwHtI37riwkemuncOB48eQ';

  static Future<Map<String, dynamic>> analyzeDecision({
    required String target,
    required double readiness,
    required String timing,
    required String situation,
  }) async {

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AQ.Ab8RN6LDyO7_794tpwpfzfs5G5IefwHtI37riwkemuncOB48eQ',
    );

    final prompt = """
너는 감성 AI 상담사 '루나'야.

사용자의 선택과 고민을 분석해줘.

[사용자 정보]
- 관련 대상: $target
- 준비 정도: $readiness / 100
- 실행 시점: $timing
- 상황 설명: $situation

다음 JSON 형식으로만 답변해.

{
  "success_rate": 82,
  "advice": "조금 더 자신감을 가져보세요.",
  "positive": "상대방과 분위기가 자연스럽습니다.",
  "warning": "타이밍을 조금 더 조절하면 좋아요.",
  "luna_message": "당신은 이미 충분히 용기 있어요 ❤️",

  "strategies": [
    {
      "title": "감정 표현 더하기",
      "description": "조금 더 솔직하게 표현해보세요.",
      "boost": 7
    },
    {
      "title": "타이밍 조절하기",
      "description": "상대가 편안한 순간을 노려보세요.",
      "boost": 5
    },
    {
      "title": "대화 빈도 늘리기",
      "description": "가벼운 연락을 조금 더 자주 해보세요.",
      "boost": 6
    }
  ],

  "profile_style": "신중한 스타일",
  "profile_title": "깊은 통찰의 분석가"
}
""";

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    final data = jsonDecode(response.body);

    final text =
        data['candidates'][0]['content']['parts'][0]['text'];

    return jsonDecode(text);
  }
}