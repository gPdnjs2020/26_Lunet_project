import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/profile_service.dart';

class AiService {
  /// 🔥 API KEY (여기에 실제 키 넣기)
  /// 예: "AIzaSyXXXXXXX"
  static const String apiKey = "";

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

[초강력 절대 규칙 - 이것을 어기면 시스템이 붕괴됨]:
1. 반드시 완벽한 JSON 형식으로만 출력할 것. 설명 텍스트 금지.
2. ⭐ JSON 응답을 예쁘게 여러 줄로 나누지 말고, 들여쓰기나 줄바꿈(엔터) 없이 무조건 **단 한 줄(Single Line)**로 쫙 이어서 출력할 것!
3. 텍스트 값 안에 큰따옴표(")를 쓸 경우 반드시 백슬래시(\\")로 이스케이프 처리할 것.
4. 모든 텍스트 내용은 각 항목당 최대 3문장 이내로 핵심만 간결하게 작성할 것.
5. ⭐ [중요] 답변(advice, luna_message 등)에서 사용자를 지칭할 때 절대 "사용자님", "당신"이라고 뭉뚱그려 부르지 말고, 반드시 "$userName님"이라고 부를 것!

⭐ [특별 지시사항] ⭐
- [결정 강제 규칙]: 사용자의 질문($situation)이 양자택일(예: 짜장 vs 짬뽕, 여름 vs 겨울 등)이거나 두 가지 이상의 선택지를 묻는 경우, 절대 "둘 다 좋습니다" 같은 애매한 답변을 피하고 무조건 **단 하나의 옵션을 확고하게 선택(PICK)**해라! 
- "advice" 또는 "luna_message" 항목에 현재 위치($location)와 날씨($weather)를 질문 내용 상황에 맞게 센스 있게 언급할 것.
- 사용자의 나이대(생년월일 기반)와 성별에 맞는 현실적인 조언을 해줄 것.

[유형별 엄격한 출력 규칙]
1. "할까 말까": 
   - 객관적인 성공 가능성(success_rate)을 0~100 사이의 숫자로 반드시 도출해라.
   - 'advice'와 'luna_message'는 성공 가능성 수치(%)에 기반하여 일관성 있게 작성해라.

2. "A or B":
   - 사용자의 질문에서 비교 대상인 두 가지 핵심 단어를 각각 'choice_a'와 'choice_b' 필드에 반드시 추출해라. (예: "여름", "겨울")
   - 'recommended' 필드에는 수식어나 문장을 절대 쓰지 말고, 오직 선택된 "단어 하나"(예: "여름")만 출력해라.
   - 'advice' 필드에 그 선택지를 고른 명확하고 설득력 있는 이유를 상세히 적어라.

3. "추천":
   - 주제에 대해 뻔하지 않고, 서로 완전히 다른 관점이나 카테고리로 범위를 넓혀서 다양하게 제안해라.

4. "고민 상담":
   - 단순한 감정 분석이 아닌, 이 상황을 극복할 수 있는 현실적이고 직접적인 조언을 해라.
   - 'core_advice' 필드에 사용자를 위한 가장 핵심적인 맞춤 해결책을 한 문장으로 요약해서 제공해라.

[strategies (상세 분석 및 전략) 작성 규칙]
'strategies' 배열에는 절대 퍼센트(%)나 수치(boost 등)를 포함하지 마라. 오직 사용자의 질문 유형(questionType)에 맞춰 아래 내용으로 3가지를 작성해라.
1. "할까 말까": 성공 확률을 더 높일 수 있는 구체적인 팁과 행동 가이드
2. "A or B": 선택된 결과를 뒷받침하는 결정적인 근거와 논리적 이유
3. "추천": 메인 추천 외에 시도해볼 만한 매력적인 차선책이나 더 나은 방안
4. "고민 상담": 상황이 앞으로 더 나아질 수 있는 긍정적인 방향과 개선 가능성

success_rate 규칙
- 반드시 0~100 정수 (대부분 30~80 사이)

출력 규칙:
- advice 300자 이하
- positive 200자 이하
- warning 200자 이하
- luna_message 200자 이하
- strategy description 150자 이하

출력 필드 (반드시 아래 필드를 모두 포함할 것, 해당 없는 항목은 "" 빈 문자열 처리):
{
  "category": "",
  "success_rate": 0,
  "advice": "",
  "core_advice": "",
  "choice_a": "",
  "choice_b": "",
  "recommended": "",
  "positive": "",
  "warning": "",
  "luna_message": "",
  "strategies": [
    {
      "title": "",
      "description": ""
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
            "temperature": 0.7,
            "topK": 20,
            "topP": 0.8,
            "maxOutputTokens": 4096,
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
