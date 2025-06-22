import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/providers/item_provider.dart';
import 'package:sisfo_sarpras_revisi/views/home/widget/item_unit_list.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildDetailCard(),
            const SizedBox(height: 24),
            _buildUnitsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placeholder gambar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.inventory, size: 40, color: Colors.grey),
        ),
        const SizedBox(width: 16),
        // Informasi item
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text('Kode: ${item.code}', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(item.type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.type.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Barang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.category, 'Kategori', item.category.name),
            _buildDetailRow(Icons.warehouse, 'Gudang', item.warehouse.name),
            _buildDetailRow(Icons.inventory, 'Stok Total', '${item.stock}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsSection(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, provider, _) {
        final units = provider.unitsForItem(item.id);
        final isLoading = provider.isLoadingUnits;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unit Barang',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (item.type.toLowerCase() == 'consumable')
              const Text('Barang habis pakai tidak memiliki unit.')
            else if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (units.isEmpty)
              const Text('Tidak ada unit tersedia.')
            else
              ItemUnitList(units: units, item: item),
          ],
        );
      },
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
      default:
        return Colors.purple;
    }
  }
}
