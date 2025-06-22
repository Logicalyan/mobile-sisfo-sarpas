import 'package:flutter/material.dart';
import 'package:sisfo_sarpras_revisi/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(CartItem cartItem) {
    if (cartItem.unit != null) {
      // Barang reusable: cek unit duplikat
      final exists = _items.any((ci) => ci.unit?.id == cartItem.unit?.id);
      if (exists) return;
    } else {
      // Barang consumable: cek apakah sudah ada item yg sama tanpa unit
      final existingIndex = _items.indexWhere(
        (ci) => ci.item.id == cartItem.item.id && ci.unit == null,
      );
      if (existingIndex != -1) {
        _items[existingIndex].quantity += cartItem.quantity;
        notifyListeners();
        return;
      }
    }

    _items.add(cartItem);
    notifyListeners();
  }

  void removeFromCart(int itemId, {int? unitId}) {
    _items.removeWhere(
      (ci) => ci.item.id == itemId && (unitId == null || ci.unit?.id == unitId),
    );
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
}
