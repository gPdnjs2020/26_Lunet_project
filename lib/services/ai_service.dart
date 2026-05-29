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
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AQ.Ab8RN6LDyO7_794tpwpfzfs5G5IefwHtI37riwkemuncOB48eQ',
    );

    final prompt = '''
너는 감성 AI 상담사 "루나"야.

사용자의 고민 분야를 먼저 분석해.

분야 종류:
- 연애
- 인간관계
- 회사/직장
- 진로
- 공부
- 가족
- 기타

⚠️ 매우 중요:
사용자의 고민 분야에 맞춰서
전략 / 조언 / 긍정요소 / 경고를 완전히 다르게 작성해야 해.

예시:
- 회사 고민인데 연애 조언 절대 금지
- 공부 고민인데 감정 표현 전략 금지
- 진로 고민인데 대화 빈도 전략 금지

사용자 정보:
- 관련 대상: $target
- 준비 정도: ${(readiness * 100).toInt()}%
- 실행 시점: $timing
- 상황 설명: $situation

반드시 JSON만 출력해.
설명 절대 추가하지 마.
마크다운 금지.
```json 금지.

응답 형식:

{
  "category": "회사",

  "success_rate": 74,

  "advice": "현재는 충분히 가능성이 있어 보여요.",

  "positive": "상황을 현실적으로 바라보고 있어요.",

  "warning": "조급하게 결론을 내리지 않는 게 좋아요.",

  "luna_message": "당신의 선택은 충분히 의미 있어요 💜",

  "strategies": [
    {
      "title": "전략 제목",
      "description": "상황 맞춤 전략 설명",
      "boost": 7
    }
  ],

  "profile_style": "분석적인 스타일",

  "profile_title": "현실 균형형"
}

전략 예시 규칙:

[연애]
- 감정 표현
- 연락 빈도
- 타이밍
- 관계 거리 조절

[회사]
- 상사 커뮤니케이션
- 업무 정리
- 리스크 관리
- 이직 타이밍
- 협업 개선

[공부]
- 집중 루틴
- 시간 관리
- 복습 전략
- 목표 세분화

[진로]
- 정보 수집
- 경험 쌓기
- 선택지 비교
- 현실 검토

[가족]
- 대화 방식
- 감정 조절
- 거리 조절
- 갈등 완화

[기타]
- 상황 분석
- 우선순위 정리
- 감정 안정
- 현실 점검

전략은 반드시 사용자 고민 분야에 맞게 생성해.
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
                {
                  "text": prompt,
                }
              ]
            }
          ],

          "generationConfig": {
            "temperature": 0.95,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1500,
          }
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'API 오류: ${response.statusCode}\n${response.body}',
        );
      }

      final data = jsonDecode(response.body);

      String text =
          data['candidates'][0]['content']['parts'][0]['text'];

      /// markdown 제거
      text = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final result = jsonDecode(text);

      return result;

    } catch (e) {

      print('AI 분석 오류: $e');

      /// fallback
      return {
        "category": "기타",

        "success_rate": 58,

        "advice":
            "조금 더 상황을 천천히 정리해보는 것이 좋아요.",

        "positive":
            "현재 상황을 진지하게 고민하고 있다는 점이 좋아요.",

        "warning":
            "감정적으로 너무 급하게 판단하지 않는 것이 중요해요.",

        "luna_message":
            "당신은 충분히 좋은 방향으로 가고 있어요 💜",

        "strategies": [
          {
            "title": "우선순위 정리하기",
            "description":
                "현재 가장 중요한 문제부터 차근차근 정리해보세요.",
            "boost": 6
          },
          {
            "title": "감정 안정시키기",
            "description":
                "불안한 상태에서 결론을 내리기보다 잠시 여유를 가져보세요.",
            "boost": 5
          },
          {
            "title": "현실적으로 상황 보기",
            "description":
                "현재 조건과 가능성을 객관적으로 다시 분석해보세요.",
            "boost": 7
          }
        ],

        "profile_style": "현실 균형형",

        "profile_title": "차분한 분석가"
      };
    }
  }
}