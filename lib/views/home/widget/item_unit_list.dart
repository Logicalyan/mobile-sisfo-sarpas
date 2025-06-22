import 'package:flutter/material.dart';
import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/models/item_unit.dart';

class ItemUnitList extends StatelessWidget {
  final List<ItemUnit> units;
  final Item item;

  const ItemUnitList({
    super.key,
    required this.units,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.qr_code),
            title: Text(unit.serialNumber),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kondisi: ${unit.condition}'),
                Text(
                  'Status: ${unit.status}',
                  style: TextStyle(color: _getStatusTextColor(unit.status)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'in_use':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
