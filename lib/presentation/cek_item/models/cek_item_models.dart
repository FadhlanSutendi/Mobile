class UnitItem {
  final String id; // tambahkan id
  final String codeUnit;
  final SubItem subItem;
  final String description;
  final String procurementDate;
  final dynamic status;
  final dynamic condition;

  UnitItem({
    required this.id, // tambahkan id
    required this.codeUnit,
    required this.subItem,
    required this.description,
    required this.procurementDate,
    required this.status,
    required this.condition,
  });

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      id: json['id'] ?? '',
      codeUnit: json['code_unit'] ?? '',
      subItem: json['sub_item'] != null
          ? SubItem.fromJson(json['sub_item'])
          : SubItem(merk: ''),
      description: json['description'] ?? '',
      procurementDate: json['procurement_date'] ?? '',
      status: json['status'],
      condition: json['condition'],
    );
  }
}

class SubItem {
  final String merk;

  SubItem({
    required this.merk,
  });

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
      merk: json['merk'] ?? '',
    );
  }
}
