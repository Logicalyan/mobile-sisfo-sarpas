import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_sarpras_revisi/models/cart_item.dart';
import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/models/item_unit.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';

class ItemUnitList extends StatelessWidget {
  final List<ItemUnit> units;
  final Item item; // Tambahkan parameter item

  const ItemUnitList({
    super.key, 
    required this.units,
    required this.item, // Wajib di-pass dari parent
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return _buildUnitCard(context, unit);
      },
    );
  }

  Widget _buildUnitCard(BuildContext context, ItemUnit unit) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final isInCart = cart.items.any((ci) => ci.unit?.id == unit.id);
        final isAvailable = unit.status.toLowerCase() == 'available';

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
                  style: TextStyle(
                    color: _getStatusTextColor(unit.status),
                  ),
                ),
              ],
            ),
            trailing: isInCart
                ? const Icon(Icons.check_circle, color: Colors.green)
                : IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    color: isAvailable ? Colors.blue : Colors.grey,
                    onPressed: isAvailable
                        ? () => _addUnitToCart(context, cart, unit)
                        : null,
                  ),
          ),
        );
      },
    );
  }

  void _addUnitToCart(BuildContext context, CartProvider cart, ItemUnit unit) {
    cart.addToCart(CartItem(
      item: item,
      unit: unit,
      addedAt: DateTime.now(),
      quantity: 1, // Quantity selalu 1 untuk unit
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unit ${unit.serialNumber} ditambahkan ke cart')),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green[100]!;
      case 'in_use':
        return Colors.blue[100]!;
      case 'maintenance':
        return Colors.orange[100]!;
      default:
        return Colors.grey[100]!;
    }
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