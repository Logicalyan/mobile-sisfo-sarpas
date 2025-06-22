import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';
import 'package:sisfo_sarpras_revisi/providers/item_provider.dart';
import 'package:sisfo_sarpras_revisi/views/home/widget/item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late Debouncer _debouncer;
  bool _isInitialLoad = true;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 500);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).fetchItems().then((_) {
        setState(() => _isInitialLoad = false);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      Provider.of<ItemProvider>(
        context,
        listen: false,
      ).filterItems(query: query);
    });
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    Provider.of<ItemProvider>(
      context,
      listen: false,
    ).filterItems(query: _searchController.text, categoryId: categoryId);
  }

  void _showSimpleCartDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cart Sementara'),
      content: Consumer<CartProvider>(
        builder: (context, cart, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in cart.items)
              ListTile(
                title: Text(item.item.name),
                subtitle: item.unit != null 
                    ? Text('Unit: ${item.unit!.serialNumber}')
                    : Text('Qty: ${item.quantity}'),
              ),
            const Divider(),
            Text('Total: ${cart.totalItems} items'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('TUTUP'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final items =
        _selectedCategoryId != null || itemProvider.searchQuery.isNotEmpty
            ? itemProvider.filteredItems
            : itemProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang Sarpras'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(itemProvider),
          _buildItemList(items, itemProvider),
        ],
      ),

      // Tambahkan di scaffold home page
      // floatingActionButton: Consumer<CartProvider>(
      //   builder: (context, cart, _) {
      //     if (cart.items.isEmpty) return const SizedBox();
      //     return FloatingActionButton(
      //       onPressed: () => _showSimpleCartDialog(context),
      //       child: Badge(
      //         label: Text('${cart.totalItems}'),
      //         child: const Icon(Icons.shopping_cart),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari barang...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                  : null,
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildCategoryFilter(ItemProvider itemProvider) {
    final categories = itemProvider.categories;
    if (categories.isEmpty) return const SizedBox(height: 12);

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          // "All" option
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Semua'),
              selected: _selectedCategoryId == null,
              onSelected: (_) => _onCategorySelected(null),
            ),
          ),
          // Category options
          ...categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category.name),
                selected: _selectedCategoryId == category.id,
                onSelected: (_) => _onCategorySelected(category.id),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildItemList(List<Item> items, ItemProvider itemProvider) {
    if (_isInitialLoad && itemProvider.items.isEmpty) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (items.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            itemProvider.searchQuery.isEmpty && _selectedCategoryId == null
                ? 'Belum ada data barang.'
                : 'Barang tidak ditemukan.',
          ),
        ),
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ItemProvider>(context, listen: false).fetchItems();
          if (_searchController.text.isNotEmpty ||
              _selectedCategoryId != null) {
            Provider.of<ItemProvider>(context, listen: false).filterItems(
              query: _searchController.text,
              categoryId: _selectedCategoryId,
            );
          }
        },
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ItemCard(item: items[index]),
            );
          },
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? _callback;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback callback) {
    _callback = callback;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), _execute);
  }

  void _execute() {
    _callback?.call();
  }

  void dispose() {
    _timer?.cancel();
  }
}
