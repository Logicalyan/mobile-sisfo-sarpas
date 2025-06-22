class BorrowTransaction {
  final int id;
  final String borrowCode;
  final DateTime borrowDate;
  final DateTime returnDate;
  final String approvalStatus;
  final String status;
  final List<BorrowDetailUnit> detailUnits;
  final List<BorrowDetailConsumable> detailConsumables;

  BorrowTransaction({
    required this.id,
    required this.borrowCode,
    required this.borrowDate,
    required this.returnDate,
    required this.approvalStatus,
    required this.status,
    required this.detailUnits,
    required this.detailConsumables,
  });

  factory BorrowTransaction.fromJson(Map<String, dynamic> json) {
  return BorrowTransaction(
    id: json['id'] ?? 0,
    borrowCode: json['borrow_code'] ?? 'BRW-${DateTime.now().millisecondsSinceEpoch}',
    borrowDate: DateTime.parse(json['borrow_date'] ?? DateTime.now().toString()),
    returnDate: DateTime.parse(json['return_date'] ?? DateTime.now().add(Duration(days: 7)).toString()),
    approvalStatus: json['approval_status'] ?? 'pending',
    status: json['status'] ?? 'not_applicable',
    detailUnits: (json['detail_units'] as List? ?? []).map((u) => BorrowDetailUnit.fromJson(u)).toList(),
    detailConsumables: (json['detail_consumables'] as List? ?? []).map((c) => BorrowDetailConsumable.fromJson(c)).toList(),
  );
}
}

class BorrowDetailUnit {
  final int itemUnitId;
  final String serialNumber;

  BorrowDetailUnit({
    required this.itemUnitId,
    required this.serialNumber,
  });

  factory BorrowDetailUnit.fromJson(Map<String, dynamic> json) {
    return BorrowDetailUnit(
      itemUnitId: json['item_unit_id'],
      serialNumber: json['item_unit']['serial_number'] ?? '',
    );
  }
}

class BorrowDetailConsumable {
  final int itemId;
  final String itemName;
  final int quantity;

  BorrowDetailConsumable({
    required this.itemId,
    required this.itemName,
    required this.quantity,
  });

  factory BorrowDetailConsumable.fromJson(Map<String, dynamic> json) {
    return BorrowDetailConsumable(
      itemId: json['item_id'],
      itemName: json['item']['name'] ?? '',
      quantity: json['quantity'],
    );
  }
}