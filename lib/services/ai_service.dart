import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  /// Gemini API Key
  static const String apiKey = '여기에_API_KEY';

  /// Gemini API URL
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  /// 감정 분석 요청
  static Future<String> analyzeEmotion(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      """
너는 감성 AI 루나야.

사용자의 감정을 분석하고:
1. 현재 감정
2. 위로 메시지
3. 현실적인 조언
4. 짧은 응원 한마디

를 따뜻하게 말해줘.

사용자 입력:
$userInput
"""
                }
              ]
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);

      final text =
          data['candidates'][0]['content']['parts'][0]['text'];

      return text;
    } catch (e) {
      return 'AI 응답 생성 실패: $e';
    }
  }
}