import 'package:flutter/material.dart';
import 'package:sisfo_sarpras_revisi/models/category.dart';
import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/models/item_unit.dart';
import '../services/item_service.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _filteredItems = []; // Tambahkan deklarasi ini
  final Map<int, List<ItemUnit>> _itemUnitsMap = {};
  List<Category> _categories = [];
  
  bool _isLoadingItems = false;
  bool _isLoadingUnits = false;
  String _searchQuery = '';
  int? _selectedCategoryId;

  // Getters
  List<Item> get items => _items;
  List<Item> get filteredItems => _filteredItems;
  List<Category> get categories => _categories;
  bool get isLoadingItems => _isLoadingItems;
  bool get isLoadingUnits => _isLoadingUnits;
  String get searchQuery => _searchQuery;
  int? get selectedCategoryId => _selectedCategoryId;

  List<ItemUnit> unitsForItem(int itemId) => _itemUnitsMap[itemId] ?? [];

  Future<void> fetchItems() async {
    _isLoadingItems = true;
    notifyListeners();

    try {
      _items = await ItemService().fetchItems();
      _categories = await ItemService().fetchCategories();
      _filteredItems = List.from(_items); // Inisialisasi filteredItems
    } catch (e) {
      debugPrint('Failed to load items: $e');
      _items = [];
      _categories = [];
      _filteredItems = [];
    }

    _isLoadingItems = false;
    notifyListeners();
  }

  // Hanya satu method filterItems yang diperlukan
  void filterItems({String? query, int? categoryId}) {
    _searchQuery = query?.toLowerCase() ?? '';
    
    _filteredItems = _items.where((item) {
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery) ||
          item.code.toLowerCase().contains(_searchQuery);

      final categoryEmpty = _selectedCategoryId == null;
      final matchesCategory = categoryId == null || 
          (item.category != null && item.category.id == categoryId);

      return matchesSearch && matchesCategory;
    }).toList();
    
    notifyListeners();
  }

  Future<void> fetchUnitsByItemId(int itemId) async {
    _isLoadingUnits = true;
    notifyListeners();

    try {
      final units = await ItemService().fetchUnitsByItemId(itemId);
      _itemUnitsMap[itemId] = units;
    } catch (e) {
      debugPrint('Error fetching units: $e');
      _itemUnitsMap[itemId] = [];
    } finally {
      _isLoadingUnits = false;
      notifyListeners();
    }
  }

  Future<void> fetchItemDetail(int itemId) async {
  if (!_itemUnitsMap.containsKey(itemId)) {
    await fetchUnitsByItemId(itemId);
  }
}
}