import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/models/item_unit.dart';

class CartItem {
  final Item item;
  final ItemUnit? unit;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.item,
    this.unit,
    this.quantity = 1,
    required this.addedAt,
  });
}