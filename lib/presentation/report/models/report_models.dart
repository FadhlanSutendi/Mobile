class ItemPercentage {
  final String name;
  final int totalBorrowed;
  final double persen;

  ItemPercentage({
    required this.name,
    required this.totalBorrowed,
    required this.persen,
  });

  factory ItemPercentage.fromJson(Map<String, dynamic> json) {
    return ItemPercentage(
      name: json['name'] ?? '',
      totalBorrowed: json['total_borrowed'] ?? 0,
      persen: (json['persen'] ?? 0).toDouble(),
    );
  }
}

class ItemCount {
  final String name;
  final int totalBorrowed;

  ItemCount({
    required this.name,
    required this.totalBorrowed,
  });

  factory ItemCount.fromJson(Map<String, dynamic> json) {
    return ItemCount(
      name: json['name'] ?? '',
      totalBorrowed: json['total_borrowed'] ?? 0,
    );
  }
}
