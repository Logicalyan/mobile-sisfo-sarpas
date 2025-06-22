import 'package:sisfo_sarpras_revisi/models/category.dart';
import 'package:sisfo_sarpras_revisi/models/warehouse.dart';

class Item {
  final int id;
  final String name;
  final String code;
  final String type;
  final int stock;
  final Category category;
  final Warehouse warehouse;

  Item({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.stock,
    required this.category,
    required this.warehouse,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      type: json['type'],
      stock: json['stock'],
      category: Category.fromJson(json['category']),
      warehouse: Warehouse.fromJson(json['warehouse']),
    );
  }
}
