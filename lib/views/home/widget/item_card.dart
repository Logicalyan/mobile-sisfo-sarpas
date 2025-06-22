import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_sarpras_revisi/models/cart_item.dart';
import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';
import 'package:sisfo_sarpras_revisi/providers/item_provider.dart';
import 'package:sisfo_sarpras_revisi/views/item/item_detail_page.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isConsumable = item.type.toLowerCase() == 'consumable';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ItemDetailPage(item: item))
          );
          Provider.of<ItemProvider>(context, listen: false)
              .fetchUnitsByItemId(item.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2, color: Colors.grey),
              ),

              const SizedBox(width: 16),

              // Name and Stock Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stok: ${item.stock}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Cart Button (for consumable) or Type Badge
              if (isConsumable)
                _buildCartButton(context)
              else
                _buildTypeBadge(item.type),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        try {
          final isInCart = cart.items.any((ci) => ci.item.id == item.id && ci.unit == null);
          
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isInCart
                ? _buildQuantityControl(context, cart)
                : IconButton(
                    key: const ValueKey('add_button'),
                    icon: const Icon(Icons.add_shopping_cart),
                    color: Colors.blue,
                    onPressed: () {
                      _addToCart(context, cart);
                    },
                  ),
          );
        } catch (e) {
          debugPrint('Error in _buildCartButton: $e');
          return const SizedBox(); // Fallback widget
        }
      },
    );
  }

  void _addToCart(BuildContext context, CartProvider cart) {
    if ((item.stock ?? 0) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stok ${item.name} habis')),
      );
      return;
    }
    
    try {
      cart.addToCart(CartItem(
        item: item,
        quantity: 1,
        addedAt: DateTime.now(),
      ));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.name} ditambahkan ke cart')),
      );
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan ke cart')),
      );
    }
  }

  Widget _buildQuantityControl(BuildContext context, CartProvider cart) {
    try {
      final cartItem = cart.items.firstWhere(
        (ci) => ci.item.id == item.id && ci.unit == null,
      );

      return Container(
        key: const ValueKey('quantity_control'),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              onPressed: () => _decreaseQuantity(context, cart, cartItem),
            ),
            Text(
              '${cartItem.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              onPressed: () => _increaseQuantity(context, cart, cartItem),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error in _buildQuantityControl: $e');
      return const SizedBox(); // Fallback widget
    }
  }

  void _decreaseQuantity(BuildContext context, CartProvider cart, CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      cart.notifyListeners();
    } else {
      cart.removeFromCart(cartItem.item.id);
    }
  }

  void _increaseQuantity(BuildContext context, CartProvider cart, CartItem cartItem) {
    if (cartItem.quantity < (item.stock ?? 0)) {
      cartItem.quantity++;
      cart.notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stok ${item.name} tidak cukup')),
      );
    }
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(type),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'consumable':
        return Colors.orange;
      case 'reusable':
        return Colors.green;
      case 'electronic':
        return Colors.blue;
      case 'furniture':
        return Colors.brown;
      default:
        return Colors.purple;
    }
  }
}