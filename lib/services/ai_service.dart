import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/profile_service.dart';

class AiService {
  /// 🔥 API KEY (여기에 실제 키 넣기)
  /// 예: "AIzaSyXXXXXXX"
  /*static const String apiKey =
      "AIzaSyBMjF4NXCph5rGbeN6W3CHs_MlG_dXt4aM";*/

  final accessToken =
      "ya29.a0AT3oNZ984JAf1Fj2LIhINAV8Tk9bqwlxET9jSZ77xWmOSPM6meOvDjidG00GQvnv6luRk6gao4ikpZ1Ecqn19ogvz7ygOX-J_35hGKLv5E0AExWETF4Nu-MmmoJjxE5ZReb1IZIbzS-lA0VOG_RP5cmeJVk6a4pYCnJdqAo8gIlCoE2yt-Cup0D8ULAjbGl0cP3wX7EaCgYKARoSARASFQHGX2Mi25DSlA3xgaMgGWF5REq0iw0206";

  static Future<Map<String, dynamic>> analyzeDecision({
    required String target,
    required double readiness,
    required String timing,
    required String situation,
    required String questionType,
    // ⭐ [추가] 지역, 생년월일, 성별, 그리고 날씨 파라미터 추가
    int retryCount = 0,
    String location = '위치 모름',
    String birthdate = '정보 없음',
    String gender = '선택 안 함',
    String weather = '알 수 없음', // ☀️ 날씨 추가!
    String userName = '사용자', // ⭐ [추가] 사용자 이름 파라미터
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

    /*if (apiKey.isEmpty || apiKey == "YOUR_GEMINI_API_KEY") {
      throw Exception("❌ API KEY를 설정하세요.");
    }*/

    String personalityPrompt = '';

    switch (personality) {
      case '철학형':
        personalityPrompt = '''
너는 철학자 스타일의 AI다.
- 깊은 통찰을 제공한다.
''';
        break;

      case '활기찬형':
        personalityPrompt = '''
너는 에너지 넘치는 코치 스타일 AI다.
- 사용자를 적극 응원한다.(긍정)
''';
        break;

      case '현실조언형':
        personalityPrompt = '''
너는 현실적인 컨설턴트 AI다.
- 감정보다 데이터와 확률을 우선한다.
''';
        break;

      default:
        personalityPrompt = '''
너는 공감형 AI 상담사다.
- 위로와 공감을 제공한다.
''';
    }

    final url = Uri.parse(
      "https://us-central1-aiplatform.googleapis.com/v1/projects/platinum-logic-499206-j5/locations/us-central1/publishers/google/models/gemini-2.5-flash:generateContent",
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
- JSON 응답을 단 한 줄(Single Line)로 쫙 이어서 출력할 것!
- 모든 텍스트 내용은 각 항목당 최대 3문장 이내로 핵심만 간결하게 작성할 것.
- [중요] 답변(advice, luna_message 등)에서 사용자를 지칭할 때 절대 "사용자님", "당신"이라고 뭉뚱그려 부르지 말고, 반드시 "$userName님"이라고 부를 것!

⭐ [특별 지시사항] ⭐
- [결정 강제 규칙]: 사용자의 질문($situation)이 양자택일(예: 짜장 vs 짬뽕, 부먹 vs 찍먹, 여름 vs 겨울 등)이거나 두 가지 이상의 선택지를 묻는 경우, 절대 "둘 다 좋습니다", "상황에 따라 다릅니다" 같은 중립적이거나 애매한 답변을 피하고 무조건 **단 하나의 옵션을 확고하게 선택(PICK)**해라! 선택한 한 가지 옵션을 'advice'에 명확히 밝히고 그 이유를 재치있고 논리적으로 설명해라.
- "advice" 또는 "luna_message" 항목의 문장 안에 전달받은 현재 위치($location)와 날씨($weather)를 질문 내용 상황에 맞게 필요하다면 언급할 것! (예: "오늘 포항은 비가 오네요! 이런 날씨엔 무조건 짬뽕입니다!")
- 사용자의 위치(지역)가 파악된다면, 해당 지역의 특색, 유명한 랜드마크를 조언에 자연스럽게 녹여내.
- 지역에 따라 어울리는 말투를 과하지 않게 살짝 섞어도 좋아.
- 사용자의 나이대(생년월일 기반)와 성별에 맞는 현실적인 조언을 해줘.

success_rate 규칙
- success_rate는 0~100 정수만 사용.
- 현실적인 값을 반환. (냉정하게)

boost 규칙
- 현실적인 상승치만 제공 (1~15 정도)
- 대부분 3~8, 매우 효과적인 전략만 10~15
- 총합이 25를 넘지 않음
- 절대로 99%를 보장하지 않음

출력 규칙:
- advice 200자 이하
- positive 150자 이하
- warning 150자 이하
- luna_message 150자 이하
- strategy description 100자 이하

질문 유형이 "추천"이면 반드시

"recommendations": [
  "",
  "",
  ""
]

필드를 포함한다.

recommendations에는 반드시
동일한 카테고리의 추천 항목 3개를 넣어라.

예:
여행 → 여행지 3개
음식 → 음식 3개
영화 → 영화 3개

관광지와 여행지를 섞지 말 것.

- advice에는 추천 이유를 작성
- success_rate는 사용하지 않음
- strategies에는 추천 목록을 넣는다.

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
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ya29.a0AT3oNZ984JAf1Fj2LIhINAV8Tk9bqwlxET9jSZ77xWmOSPM6meOvDjidG00GQvnv6luRk6gao4ikpZ1Ecqn19ogvz7ygOX-J_35hGKLv5E0AExWETF4Nu-MmmoJjxE5ZReb1IZIbzS-lA0VOG_RP5cmeJVk6a4pYCnJdqAo8gIlCoE2yt-Cup0D8ULAjbGl0cP3wX7EaCgYKARoSARASFQHGX2Mi25DSlA3xgaMgGWF5REq0iw0206",
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": prompt},
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 20,
            "topP": 0.8,
            "maxOutputTokens": 8192,
            "responseMimeType": "application/json",
            "responseSchema": {
              "type": "OBJECT",
              "properties": {
                "category": {"type": "STRING"},
                "success_rate": {"type": "INTEGER"},
                "advice": {"type": "STRING"},
                "positive": {"type": "STRING"},
                "warning": {"type": "STRING"},
                "luna_message": {"type": "STRING"},
                "strategies": {
                  "type": "ARRAY",
                  "items": {
                    "type": "OBJECT",
                    "properties": {
                      "title": {"type": "STRING"},
                      "description": {"type": "STRING"},
                      "boost": {"type": "INTEGER"},
                    },
                  },
                },
              },
            },
          },
        }),
      );
      print("========== HEADERS ==========");
      print(response.headers);

      try {
        final errorJson = jsonDecode(response.body);

        if (errorJson["error"] != null) {
          print("========== ERROR DETAILS ==========");
          print(errorJson["error"]["message"]);
          print(errorJson["error"]["status"]);
          print(errorJson["error"]["details"]);
        }
      } catch (_) {}

      print("=================================");
      print("📡 STATUS: ${response.statusCode}");
      print("=================================");
      print("📡 RAW RESPONSE:");
      print(response.body);
      print("=================================");

      if (response.statusCode == 503 && retryCount < 3) {
        print("⚠️ Gemini 서버 과부하. 2초 후 재시도");

        await Future.delayed(const Duration(seconds: 10));

        return analyzeDecision(
          target: target,
          readiness: readiness,
          timing: timing,
          situation: situation,
          questionType: questionType,
          location: location,
          birthdate: birthdate,
          gender: gender,
          weather: weather,
          userName: userName,
          retryCount: retryCount + 1,
        );
      }

      if (response.statusCode != 200) {
        throw Exception("API 실패: ${response.body}");
      }

      final data = jsonDecode(response.body);

      String text = data['candidates'][0]['content']['parts'][0]['text'];

      print("=================================");
      print("🤖 RAW AI TEXT:");
      print("TEXT LENGTH = ${text.length}");
      print(text.endsWith('}'));
      print(text.substring(text.length > 500 ? text.length - 500 : 0));
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
      String cleanText = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

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
