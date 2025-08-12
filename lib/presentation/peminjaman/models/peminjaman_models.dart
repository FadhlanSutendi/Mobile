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

  Teacher({required this.id, required this.name});

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['id'],
    name: json['name'],
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
  });

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
