class HistoryModel {
  final String title;
  final int successRate;
  final String category;
  final String situation;
  final String date;

  HistoryModel({
    required this.title,
    required this.successRate,
    required this.category,
    required this.situation,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'successRate': successRate,
      'category': category,
      'situation': situation,
      'date': date,
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
    );
  }
}