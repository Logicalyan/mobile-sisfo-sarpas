import 'package:flutter/material.dart';
import 'package:sisfo_sarpras_revisi/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(CartItem cartItem) {
  // Untuk unit, pastikan tidak ada duplikat
  if (cartItem.unit != null) {
    final exists = _items.any((ci) => ci.unit?.id == cartItem.unit?.id);
    if (exists) return;
  }
  
  _items.add(cartItem);
  notifyListeners();
}

void removeFromCart(int itemId, {int? unitId}) {
  _items.removeWhere((ci) => 
      ci.item.id == itemId && 
      (unitId == null || ci.unit?.id == unitId));
  notifyListeners();
}

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
}