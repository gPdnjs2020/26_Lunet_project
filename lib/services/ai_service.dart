import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/profile_service.dart';

class AiService {
  /// 🔥 API KEY (여기에 실제 키 넣기)
  /// 예: "AIzaSyXXXXXXX"
  static const String apiKey =
      "AQ.Ab8RN6LvSgU3dz2quAJ8bNM-yAnrBmwI87RnU7F9nRSOMYiuig";

  static Future<Map<String, dynamic>> analyzeDecision({
    required String target,
    required double readiness,
    required String timing,
    required String situation,
    required String questionType,
    // ⭐ [추가] 지역, 생년월일, 성별, 그리고 날씨 파라미터 추가
    String location = '위치 모름',
    String birthdate = '정보 없음',
    String gender = '선택 안 함',
    String weather = '알 수 없음', // ☀️ 날씨 추가!
  }) async {
    final personality = await ProfileService.loadPersonality();
    print("=================================");
    print("🚀 AI REQUEST START");
    print("target: $target");
    print("readiness: $readiness");
    print("timing: $timing");
    print("situation: $situation");
    print("questionType: $questionType");
    print("location: $location");
    print("birthdate: $birthdate");
    print("gender: $gender");
    print("weather: $weather"); // ☀️ 로그에도 출력
    print("personality: $personality");
    print("=================================");

    if (apiKey.isEmpty || apiKey == "YOUR_GEMINI_API_KEY") {
      throw Exception("❌ API KEY를 설정하세요.");
    }

    String personalityPrompt = '';

    switch (personality) {
      case '철학형':
        personalityPrompt = '''
너는 철학자 스타일의 AI다.

- 정답을 주기보다 생각할 질문을 던진다.
- 인간의 가치와 의미를 탐구한다.
- 깊은 통찰을 제공한다.
''';
        break;

      case '활기찬형':
        personalityPrompt = '''
너는 에너지 넘치는 코치 스타일 AI다.

- 사용자를 적극 응원한다.
- 용기와 자신감을 북돋아 준다.
- 긍정적인 표현을 자주 사용한다.
''';
        break;

      case '현실조언형':
        personalityPrompt = '''
너는 현실적인 컨설턴트 AI다.

- 감정보다 데이터와 확률을 우선한다.
- 객관적인 장단점을 분석한다.
- 냉정하고 실용적인 조언을 제공한다.
''';
        break;

      default:
        personalityPrompt = '''
너는 공감형 AI 상담사다.

- 사용자의 감정을 먼저 이해한다.
- 따뜻하고 부드럽게 말한다.
- 위로와 공감을 제공한다.
''';
    }

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
    );

    final prompt =
        '''
너는 AI "루나"야.

$personalityPrompt

절대 규칙:
- JSON만 출력
- 설명 금지
- 누락 금지
- 키 이름 변경 금지

⭐ [특별 지시사항] ⭐
- 사용자의 위치(지역)가 파악된다면, 해당 지역의 특색, 유명한 데이트 코스나 랜드마크(예: 서울이면 한강, 대구면 동성로, 포항이면 영일대 등)를 조언에 자연스럽게 녹여내.
- 지역에 따라 어울리는 말투나 친근한 사투리 뉘앙스를 아주 살짝 섞어도 좋아. (예: 경상도 지역이면 경상도 느낌으로)
- 사용자의 나이대(생년월일 기반)와 성별에 맞는 현실적이고 구체적인 조언을 해줘.
- ☀️ 현재 날씨 상태를 적극적으로 반영해! (예: 비가 오면 실내 데이트나 파전에 막걸리 비유를 쓰고, 맑으면 야외 활동이나 산뜻한 분위기를 강조해).

success_rate 규칙

- 반드시 0~100 정수
- 100을 초과하면 안 됨
- 현실적인 수치 사용
- 대부분 30~80 사이
- 정말 유리한 상황만 90 이상
- 95 이상은 매우 드문 경우만 허용

boost 규칙

- 현실적인 상승치만 제공
- 1~15 범위
- 대부분 3~8
- 매우 효과적인 전략만 10~15
- 총합이 25를 넘지 않음
- 절대로 99%를 보장하지 않음

출력 필드 (반드시 모두 포함):

{
  "category": "",
  "success_rate": 0,
  "advice": "",
  "positive": "",
  "warning": "",
  "luna_message": "",
  "strategies": [
    {
      "title": "",
      "description": "",
      "boost": 0
    }
  ],
  "profile_style": "",
  "profile_title": ""
}

사용자 정보:
- 대상: $target
- 준비도: ${readiness.toStringAsFixed(0)}%
- 타이밍: $timing
- 상황: $situation
- 질문 유형: $questionType
- 📍 현재 위치: $location
- 🎂 생년월일: $birthdate
- 👤 성별: $gender
- 🌤️ 현재 날씨: $weather
''';

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.9,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 3000,
          },
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

      String text = data['candidates'][0]['content']['parts'][0]['text'];

      print("=================================");
      print("🤖 RAW AI TEXT:");
      print(text);
      print("=================================");

      /// JSON 정리
      text = text.replaceAll("```json", "").replaceAll("```", "").trim();

      /// 🔥 안전 JSON 추출 (RegExp 제거)
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');

      if (start == -1 || end == -1 || start > end) {
        throw Exception("JSON 파싱 실패 (구조 없음)");
      }

      final cleanJson = text.substring(start, end + 1);

      print("=================================");
      print("📦 FINAL JSON:");
      print(cleanJson);
      print("=================================");

      return jsonDecode(cleanJson);
    } catch (e) {
      print("=================================");
      print("❌ AI ERROR");
      print(e);
      print("=================================");

      return {
        "category": "기타",
        "success_rate": 50,
        "advice": "AI 오류 발생",
        "positive": "다시 시도하세요",
        "warning": "API 상태 확인 필요",
        "luna_message": "잠시 후 다시 시도해 주세요 💜",
        "strategies": [],
        "profile_style": "error",
        "profile_title": "error",
      };
    }
  }
}
