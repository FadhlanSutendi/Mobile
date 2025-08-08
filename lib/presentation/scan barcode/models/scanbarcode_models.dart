class SubItem {
  final String id;
  final String merk;
  final int stock;
  final String unit;

  SubItem({
    required this.id,
    required this.merk,
    required this.stock,
    required this.unit,
  });

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
      id: json['id'] ?? '',
      merk: json['merk'] ?? '',
      stock: json['stock'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}

class UnitItem {
  final String id;
  final String codeUnit;
  final String description;
  final String procurementDate;
  final int status;
  final int condition;
  final String qrcode;
  final SubItem subItem;

  UnitItem({
    required this.id,
    required this.codeUnit,
    required this.description,
    required this.procurementDate,
    required this.status,
    required this.condition,
    required this.qrcode,
    required this.subItem,
  });

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      id: json['id'] ?? '',
      codeUnit: json['code_unit'] ?? '',
      description: json['description'] ?? '',
      procurementDate: json['procurement_date'] ?? '',
      status: json['status'] ?? 0,
      condition: json['condition'] ?? 0,
      qrcode: json['qrcode'] ?? '',
      subItem: json['sub_item'] != null
          ? SubItem.fromJson(json['sub_item'])
          : SubItem(id: '', merk: '', stock: 0, unit: ''),
    );
  }
}
