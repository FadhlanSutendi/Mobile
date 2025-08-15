import '../../peminjaman/models/peminjaman_models.dart'; // import Loan

class UnitItem {
  final String id; // tambahkan id
  final String codeUnit;
  final SubItem subItem;
  final String description;
  final String procurementDate;
  final dynamic status;
  final dynamic condition;
  final Loan? loan; // add this field

  UnitItem({
    required this.id,
    required this.codeUnit,
    required this.subItem,
    required this.description,
    required this.procurementDate,
    required this.status,
    required this.condition,
    this.loan,
  });

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      id: json['id'] ?? '', // this should be the UUID for unit_item_id
      codeUnit: json['code_unit'] ?? '',
      subItem: json['sub_item'] != null
          ? SubItem.fromJson(json['sub_item'])
          : SubItem(merk: ''),
      description: json['description'] ?? '',
      procurementDate: json['procurement_date'] ?? '',
      status: json['status'],
      condition: json['condition'],
      loan: json['loan'] != null ? Loan.fromJson(json['loan']) : null, // parse loan
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
