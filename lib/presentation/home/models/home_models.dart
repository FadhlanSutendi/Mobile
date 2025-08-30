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

class LoanReportModel {
  final int status;
  final Map<String, int> monthlyData;

  LoanReportModel({required this.status, required this.monthlyData});

  factory LoanReportModel.fromJson(Map<String, dynamic> json) {
    return LoanReportModel(
      status: json['status'] ?? 0,
      monthlyData: Map<String, int>.from(json['data'] ?? {}),
    );
  }
}

class LatestActivityModel {
  // NOTE: Assumes flat JSON structure. If nested, adjust parsing accordingly.
  final String id;
  final String item;
  final String subItem;
  final String borrowedAt;
  final String borrowerName;

  LatestActivityModel({
    required this.id,
    required this.item,
    required this.subItem,
    required this.borrowedAt,
    required this.borrowerName,
  });

  factory LatestActivityModel.fromJson(Map<String, dynamic> json) {
    return LatestActivityModel(
      id: json['id'] ?? '',
      item: json['item'] ?? '',
      subItem: json['sub_item'] ?? '',
      borrowedAt: json['borrowed_at'] ?? '',
      borrowerName: json['borrower_name'] ?? '',
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String username;
  final String role;
  final int majorId;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.majorId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      majorId: json['major_id'] ?? 0,
    );
  }
}