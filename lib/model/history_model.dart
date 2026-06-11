class HistoryModel {
  final String title;
  final int successRate;
  final String category;
  final String situation;
  final String date;

  final String questionType; // ✨ 추가: "A or B", "추천" 등 질문 유형 저장!

  final String userResult;

  final String advice;
  final String positive;
  final String warning;
  final String lunaMessage;

  final String profileTitle;
  final String profileStyle;

  HistoryModel({
    required this.title,
    required this.successRate,
    required this.category,
    required this.situation,
    required this.date,

    this.questionType = '', // ✨ 기존에 저장된 데이터에서 에러 안 나도록 기본값 설정

    this.userResult = '',

    this.advice = '',
    this.positive = '',
    this.warning = '',
    this.lunaMessage = '',
    this.profileTitle = '',
    this.profileStyle = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'successRate': successRate,
      'category': category,
      'questionType': questionType, // ✨ 저장할 때 포함
      'situation': situation,
      'date': date,
      'userResult': userResult,

      'advice': advice,
      'positive': positive,
      'warning': warning,
      'lunaMessage': lunaMessage,
      'profileTitle': profileTitle,
      'profileStyle': profileStyle,
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    // ✨ 빈 칸("")으로 저장된 예전 데이터들을 감지해서 복구하는 마법의 코드
    String loadedQType = json['questionType'] ?? '할까 말까';
    if (loadedQType.trim().isEmpty) {
      loadedQType = '할까 말까';
    }

    return HistoryModel(
      title: json['title'] ?? '',
      successRate: json['successRate'] ?? 50,
      category: json['category'] ?? '기타',
      situation: json['situation'] ?? '',
      date: json['date'] ?? '',

      // ✨ 복구된 진짜 카테고리를 넣어줍니다!
      questionType: loadedQType,

      userResult: json['userResult'] ?? '',
      advice: json['advice'] ?? '',
      positive: json['positive'] ?? '',
      warning: json['warning'] ?? '',
      lunaMessage: json['lunaMessage'] ?? '',
      profileTitle: json['profileTitle'] ?? '',
      profileStyle: json['profileStyle'] ?? '',
    );
  }
}
