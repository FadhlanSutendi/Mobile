class UnitLoan {
  final String id;
  final String unitItemId;
  final String? studentId;
  final String? teacherId;
  final String borrowedBy;
  final String borrowedAt;
  final String? returnedAt;
  final String purpose;
  final dynamic room;
  final bool status;
  final String? image;
  final String guarantee;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? teacher;
  final UnitItem unitItem;

  UnitLoan({
    required this.id,
    required this.unitItemId,
    this.studentId,
    this.teacherId,
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
    required this.unitItem,
  });

  factory UnitLoan.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    return UnitLoan(
      id: parseString(json['id']) ?? '',
      unitItemId: parseString(json['unit_item_id']) ?? '',
      studentId: parseString(json['student_id']),
      teacherId: parseString(json['teacher_id']),
      borrowedBy: parseString(json['borrowed_by']) ?? '',
      borrowedAt: parseString(json['borrowed_at']) ?? '',
      returnedAt: parseString(json['returned_at']),
      purpose: parseString(json['purpose']) ?? '',
      room: json['room'],
      status: json['status'] == true,
      image: parseString(json['image']),
      guarantee: parseString(json['guarantee']) ?? '',
      createdAt: parseString(json['created_at']) ?? '',
      updatedAt: parseString(json['updated_at']) ?? '',
      student: json['student'],
      teacher: json['teacher'],
      unitItem: json['unit_item'] != null
          ? UnitItem.fromJson(json['unit_item'])
          : UnitItem(
              id: '',
              codeUnit: '',
              subItem: SubItem(merk: ''),
              description: '',
              procurementDate: '',
              status: '',
              condition: '',
            ),
    );
  }
}

// Minimal UnitItem and SubItem for dependency
class UnitItem {
  final String id;
  final String codeUnit;
  final SubItem subItem;
  final String description;
  final String procurementDate;
  final dynamic status;
  final dynamic condition;

  UnitItem({
    required this.id,
    required this.codeUnit,
    required this.subItem,
    required this.description,
    required this.procurementDate,
    required this.status,
    required this.condition,
  });

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    return UnitItem(
      id: parseString(json['id']) ?? '',
      codeUnit: parseString(json['code_unit']) ?? '',
      subItem: json['sub_item'] != null
          ? SubItem.fromJson(json['sub_item'])
          : SubItem(merk: ''),
      description: parseString(json['description']) ?? '',
      procurementDate: parseString(json['procurement_date']) ?? '',
      status: json['status'],
      condition: json['condition'],
    );
  }
}

class SubItem {
  final String merk;

  SubItem({required this.merk});

  factory SubItem.fromJson(Map<String, dynamic> json) {
    String? parseString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return SubItem(
      merk: parseString(json['merk']) ?? '',
    );
  }
}
