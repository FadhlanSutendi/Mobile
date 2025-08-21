class HistoryItem {
  final String id;
  final String borrowedBy;
  final String borrowedAt;
  final String? returnedAt;
  final String purpose;
  final int room;
  final bool status;
  final String guarantee;
  final String? image;
  final String? studentName;
  final String? teacherName;
  final String codeUnit;
  final String itemType;
  final String merk;

  HistoryItem({
    required this.id,
    required this.borrowedBy,
    required this.borrowedAt,
    this.returnedAt,
    required this.purpose,
    required this.room,
    required this.status,
    required this.guarantee,
    this.image,
    this.studentName,
    this.teacherName,
    required this.codeUnit,
    required this.itemType,
    required this.merk,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    final unitItem = json['unit_item'] ?? {};
    final subItem = unitItem['sub_item'] ?? {};
    final item = subItem['item'] ?? {};
    return HistoryItem(
      id: json['id'] ?? '',
      borrowedBy: json['borrowed_by'] ?? '',
      borrowedAt: json['borrowed_at'] ?? '',
      returnedAt: json['returned_at'],
      purpose: json['purpose'] ?? '',
      room: json['room'] ?? 0,
      status: json['status'] == "returned" ? true : false,
      guarantee: json['guarantee'] ?? '',
      image: json['image'],
      studentName: json['student']?['name'],
      teacherName: json['teacher']?['name'],
      codeUnit: unitItem['code_unit'] ?? '',
      itemType: item['name'] ?? '',
      merk: subItem['merk'] ?? '',
    );
  }
}