import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {

  static const String apiKey = String.fromEnvironment(
    'AQ.Ab8RN6LDyO7_794tpwpfzfs5G5IefwHtI37riwkemuncOB48eQ',
    defaultValue: '',
  );

  static Future<Map<String, dynamic>> analyzeDecision({
    required String target,
    required double readiness,
    required String timing,
    required String situation,
  }) async {

    print("=================================");
    print("🚀 AI REQUEST START");
    print("target: $target");
    print("readiness: $readiness");
    print("timing: $timing");
    print("situation: $situation");
    print("=================================");

    if (apiKey.isEmpty) {
      throw Exception("❌ API KEY가 설정되지 않았습니다.");
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AQ.Ab8RN6LDyO7_794tpwpfzfs5G5IefwHtI37riwkemuncOB48eQ',
    );

    final prompt = '''
너는 감성 AI 상담사 "루나"야.

반드시 JSON만 출력해야 한다.
설명 금지.
코드블럭 금지.

사용자 정보:
- 대상: $target
- 준비도: ${(readiness * 100).toInt()}%
- 타이밍: $timing
- 상황: $situation

출력 형식:
{
  "category": "회사",
  "success_rate": 74,
  "advice": "예시",
  "positive": "예시",
  "warning": "예시",
  "luna_message": "예시",
  "strategies": [
    {
      "title": "전략",
      "description": "설명",
      "boost": 7
    }
  ],
  "profile_style": "스타일",
  "profile_title": "타이틀"
}
''';

    try {
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
          ],
          "generationConfig": {
            "temperature": 0.9,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1500,
          }
        }),
      );

      print("=================================");
      print("📡 STATUS: ${response.statusCode}");
      print("=================================");
      print("📡 RAW RESPONSE:");
      print(response.body);
      print("=================================");

      if (response.statusCode != 200) {
        throw Exception("API 실패: ${response.body}");
      }

      final data = jsonDecode(response.body);

      String text =
          data['candidates'][0]['content']['parts'][0]['text'];

      print("=================================");
      print("🤖 RAW AI TEXT:");
      print(text);
      print("=================================");

      /// 🔥 1차 정리
      text = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      print("=================================");
      print("🧹 CLEANED TEXT:");
      print(text);
      print("=================================");

      /// 🔥 JSON 추출 안전 처리
      final reg = RegExp(r'\{.*\}', dotAll: true);
      final match = reg.firstMatch(text);

      if (match == null) {
        print("❌ JSON NOT FOUND");
        throw Exception("JSON 파싱 실패 (정규식 실패)");
      }

      final cleanJson = match.group(0)!;

      print("=================================");
      print("📦 FINAL JSON STRING:");
      print(cleanJson);
      print("=================================");

      final result = jsonDecode(cleanJson);

      print("=================================");
      print("✅ PARSED RESULT SUCCESS");
      print(result);
      print("=================================");

      return result;

    } catch (e) {
      print("=================================");
      print("❌ AI ERROR OCCURRED");
      print(e);
      print("=================================");

      return {
        "category": "기타",
        "success_rate": 50,
        "advice": "AI 실패 (로그 확인 필요)",
        "positive": "다시 시도",
        "warning": "API/응답 문제",
        "luna_message": "디버그 모드입니다 💜",
        "strategies": [],
        "profile_style": "debug",
        "profile_title": "debug"
      };
    }
  }
}