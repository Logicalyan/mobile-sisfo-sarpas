import 'package:sisfo_sarpras_revisi/models/item.dart';

class ItemUnit {
  final int id;
  final int itemId;
  final String serialNumber;
  final String condition;
  final String status;
  final Item? item;

  ItemUnit({
    required this.id,
    required this.itemId,
    required this.serialNumber,
    required this.condition,
    required this.status,
    this.item,
  });

  factory ItemUnit.fromJson(Map<String, dynamic> json) {
    // Handle nested item
    dynamic itemJson = json['item'];
    Item? item;

    try {
      if (itemJson != null && itemJson is Map) {
        item = Item.fromJson(itemJson.cast<String, dynamic>());
      }
    } catch (e) {
      print('Error parsing item: $e');
    }

    return ItemUnit(
      id: (json['id'] as int?) ?? 0,
      itemId: (json['item_id'] as int?) ?? 0,
      serialNumber: (json['serial_number'] as String?) ?? '',
      condition: (json['condition'] as String?) ?? 'unknown',
      status: (json['status'] as String?) ?? 'unknown',
      item: item, // Bisa null
    );
  }
}
