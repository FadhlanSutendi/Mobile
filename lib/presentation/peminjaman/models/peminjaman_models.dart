class Student {
  final String id;
  final String nis;
  final String name;
  final String rayon;
  final String major;

  Student({required this.id, required this.nis, required this.name, required this.rayon, required this.major});

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'],
    nis: json['nis'].toString(),
    name: json['name'],
    rayon: json['rayon'],
    major: json['major'] is Map ? json['major']['name'] : json['major'],
  );
}

class Teacher {
  final String id;
  final String name;
  final String nip;
  final String telephone;

  Teacher({
    required this.id,
    required this.name,
    required this.nip,
    required this.telephone,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['id'],
    name: json['name'],
    nip: json['nip'] ?? '',
    telephone: json['telephone'] ?? '',
  );
}

class LoanRequest {
  String? studentId;
  String? teacherId;
  String unitItemId;
  String borrowedBy;
  String borrowedAt;
  String? returnedAt;
  String purpose;
  int room;
  String? imagePath;
  String guarantee;

  LoanRequest({
    this.studentId,
    this.teacherId,
    required this.unitItemId,
    required this.borrowedBy,
    required this.borrowedAt,
    this.returnedAt,
    required this.purpose,
    required this.room,
    this.imagePath,
    required this.guarantee,
  }) : assert(guarantee == 'BKP' || guarantee == 'kartu pelajar', 'Guarantee must be BKP or kartu pelajar');

  Map<String, dynamic> toMap() => {
    if (studentId != null) 'student_id': studentId,
    if (teacherId != null) 'teacher_id': teacherId,
    'unit_item_id': unitItemId,  
    'borrowed_by': borrowedBy,
    'borrowed_at': borrowedAt,
    if (returnedAt != null) 'returned_at': returnedAt,
    'purpose': purpose,
    'room': room,
    if (imagePath != null) 'image': imagePath,
    'guarantee': guarantee,
  };
}

class Loan {
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
  final Student? student;
  final Teacher? teacher;
  final LoanUnitItem? unitItem;

  Loan({
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
    this.student,
    this.teacher,
    this.unitItem,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
    id: json['id'],
    studentId: json['student_id'],
    teacherId: json['teacher_id'],
    unitItemId: json['unit_item_id'],
    borrowedBy: json['borrowed_by'],
    borrowedAt: json['borrowed_at'],
    returnedAt: json['returned_at'],
    purpose: json['purpose'],
    room: json['room'] is int ? json['room'] : int.tryParse(json['room'].toString()) ?? 0,
    status: json['status'] == true || json['status'] == 1,
    image: json['image'],
    guarantee: json['guarantee'] ?? '',
    student: json['student'] != null ? Student(
      id: json['student']['id'],
      nis: json['student']['nis'].toString(),
      name: json['student']['name'] ?? '',
      rayon: json['student']['rayon'] ?? '',
      major: json['student']['major'] is Map
        ? json['student']['major']['name'] ?? ''
        : (json['student']['major'] ?? ''),
    ) : null,
    teacher: json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
    unitItem: json['unit_item'] != null ? LoanUnitItem.fromJson(json['unit_item']) : null,
  );
}

class LoanUnitItem {
  final String id;
  final String subItemId;
  final String codeUnit;
  final String description;
  final String procurementDate;
  final dynamic status;
  final dynamic condition;
  final String? qrcode;
  final LoanSubItem? subItem;

  LoanUnitItem({
    required this.id,
    required this.subItemId,
    required this.codeUnit,
    required this.description,
    required this.procurementDate,
    required this.status,
    required this.condition,
    this.qrcode,
    this.subItem,
  });

  factory LoanUnitItem.fromJson(Map<String, dynamic> json) => LoanUnitItem(
    id: json['id'] ?? '',
    subItemId: json['sub_item_id'] ?? '',
    codeUnit: json['code_unit'] ?? '',
    description: json['description'] ?? '',
    procurementDate: json['procurement_date'] ?? '',
    status: json['status'],
    condition: json['condition'],
    qrcode: json['qrcode'],
    subItem: json['sub_item'] != null ? LoanSubItem.fromJson(json['sub_item']) : null,
  );
}

class LoanSubItem {
  final String id;
  final String itemId;
  final String? name;
  final String? description;
  final String merk;
  final int? stock;
  final String? unit;
  final int? majorId;
  final LoanItem? item;

  LoanSubItem({
    required this.id,
    required this.itemId,
    this.name,
    this.description,
    required this.merk,
    this.stock,
    this.unit,
    this.majorId,
    this.item,
  });

  factory LoanSubItem.fromJson(Map<String, dynamic> json) => LoanSubItem(
    id: json['id'] ?? '',
    itemId: json['item_id'] ?? '',
    name: json['name'],
    description: json['description'],
    merk: json['merk'] ?? '',
    stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock']?.toString() ?? ''),
    unit: json['unit'],
    majorId: json['major_id'] is int ? json['major_id'] : int.tryParse(json['major_id']?.toString() ?? ''),
    item: json['item'] != null ? LoanItem.fromJson(json['item']) : null,
  );
}

class LoanItem {
  final String id;
  final String name;

  LoanItem({
    required this.id,
    required this.name,
  });

  factory LoanItem.fromJson(Map<String, dynamic> json) => LoanItem(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
  );
}