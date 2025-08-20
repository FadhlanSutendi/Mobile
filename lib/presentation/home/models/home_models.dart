class CardOverview {
  final int reuse;
  final int used;
  final int good;
  final int down;
  final int dailyData;
  final int monthlyData;

  CardOverview({
    required this.reuse,
    required this.used,
    required this.good,
    required this.down,
    required this.dailyData,
    required this.monthlyData,
  });

  factory CardOverview.fromJson(Map<String, dynamic> json) {
    return CardOverview(
      reuse: json['reuse'] ?? 0,
      used: json['used'] ?? 0,
      good: json['good'] ?? 0,
      down: json['down'] ?? 0,
      dailyData: json['daily_data'] ?? 0,
      monthlyData: json['monthly_data'] ?? 0,
    );
  }
}

class ActivityItemModel {
  final String name;
  final String date;

  ActivityItemModel({required this.name, required this.date});

  factory ActivityItemModel.fromJson(Map<String, dynamic> json) {
    return ActivityItemModel(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
