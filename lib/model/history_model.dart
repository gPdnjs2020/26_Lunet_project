class HistoryModel {
  final String title;
  final int successRate;
  final String category;
  final String situation;
  final String date;

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

  factory HistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HistoryModel(
      title: json['title'],
      successRate: json['successRate'],
      category: json['category'],
      situation: json['situation'],
      date: json['date'],
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