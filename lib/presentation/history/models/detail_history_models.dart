class DetailHistoryModel {
  final String id;
  final String? studentId;
  final String? teacherId;
  final String unitItemId;
  final String borrowedBy;
  final String borrowedAt;
  final String? returnedAt;
  final String purpose;
  final int room;
  final bool status;
  final String? image;
  final String guarantee;
  final String createdAt;
  final String updatedAt;
  final Student? student;
  final Teacher? teacher;
  final UnitItem? unitItem;

  DetailHistoryModel({
    required this.id,
    this.studentId,
    this.teacherId,
    required this.unitItemId,
    required this.borrowedBy,
    required this.borrowedAt,
    this.returnedAt,
    required this.purpose,
    required this.room,
    required this.status,
    this.image,
    required this.guarantee,
    required this.createdAt,
    required this.updatedAt,
    this.student,
    this.teacher,
    this.unitItem,
  });

  factory DetailHistoryModel.fromJson(Map<String, dynamic> json) {
    return DetailHistoryModel(
      id: json['id'],
      studentId: json['student_id'],
      teacherId: json['teacher_id'],
      unitItemId: json['unit_item_id'],
      borrowedBy: json['borrowed_by'],
      borrowedAt: json['borrowed_at'],
      returnedAt: json['returned_at'],
      purpose: json['purpose'],
      room: json['room'],
      status: json['status'],
      image: json['image'],
      guarantee: json['guarantee'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      student: json['student'] != null ? Student.fromJson(json['student']) : null,
      teacher: json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      unitItem: json['unit_item'] != null ? UnitItem.fromJson(json['unit_item']) : null,
    );
  }
}

class Student {
  final String id;
  final String name;
  final int nis;
  final String rayon;
  final int majorId;
  final String createdAt;
  final String updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.nis,
    required this.rayon,
    required this.majorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      nis: json['nis'],
      rayon: json['rayon'],
      majorId: json['major_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Teacher {
  // Implement if needed
  Teacher();

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher();
  }
}

class UnitItem {
  final String id;
  final String subItemId;
  final String codeUnit;
  final String description;
  final String procurementDate;
  final bool status;
  final bool condition;
  final String qrcode;
  final String createdAt;
  final String updatedAt;

  UnitItem({
    required this.id,
    required this.subItemId,
    required this.codeUnit,
    required this.description,
    required this.procurementDate,
    required this.status,
    required this.condition,
    required this.qrcode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      id: json['id'],
      subItemId: json['sub_item_id'],
      codeUnit: json['code_unit'],
      description: json['description'],
      procurementDate: json['procurement_date'],
      status: json['status'],
      condition: json['condition'],
      qrcode: json['qrcode'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
