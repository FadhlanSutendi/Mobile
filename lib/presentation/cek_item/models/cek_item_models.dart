class UnitItem {
  final String id; // tambahkan id
  final String codeUnit;
  final SubItem subItem;
  final String description;
  final String procurementDate;
  final dynamic status;
  final dynamic condition;
  // Tambahkan type di UnitItem agar mudah diakses
  final String? type;

  UnitItem({
    required this.id, 
    required this.codeUnit,
    required this.subItem,
    required this.description,
    required this.procurementDate,
    required this.status,
    required this.condition,
    this.type,
  });

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      id: json['id'] ?? '', // this should be the UUID for unit_item_id
      codeUnit: json['code_unit'] ?? '',
      subItem: json['sub_item'] != null
          ? SubItem.fromJson(json['sub_item'])
          : SubItem(merk: '', type: ''),
      description: json['description'] ?? '',
      procurementDate: json['procurement_date'] ?? '',
      status: json['status'],
      condition: json['condition'],
      type: json['sub_item'] != null ? (json['sub_item']['type'] ?? '') : '',
    );
  }
}

class SubItem {
  final String merk;
  final String type; // tambahkan type

  SubItem({
    required this.merk,
    required this.type,
  });

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
      merk: json['merk'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
