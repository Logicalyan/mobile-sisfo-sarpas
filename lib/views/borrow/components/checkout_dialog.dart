import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sisfo_sarpras_revisi/models/cart_item.dart';
import 'package:sisfo_sarpras_revisi/providers/borrow_provider.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';

void showCheckoutDialog(BuildContext context, List<CartItem> cartItems) {
  if (cartItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Keranjang tidak boleh kosong"))
    );
    return;
  }
  final borrowProvider = Provider.of<BorrowProvider>(context, listen: false);
  final cartProvider = Provider.of<CartProvider>(context, listen: false);

  DateTime borrowDate = DateTime.now();
  DateTime returnDate = DateTime.now();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Proses Peminjaman'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Tanggal Peminjaman:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat(
                      'EEEE, dd MMMM yyyy',
                    ).format(borrowDate),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tanggal Pengembalian:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CalendarDatePicker(
                    initialDate: returnDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateChanged: (date) => setState(() => returnDate = date),
                  ),
                  const SizedBox(height: 16),
                  _buildItemsSummary(cartItems),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                ),
                onPressed: () async {
                  final scaffold = ScaffoldMessenger.of(context);
                  try {
                    print("Borrow Date: $borrowDate");
                    print("Return Date: $returnDate");
                    final reusableUnits =
                        cartItems
                            .where((item) => item.unit != null)
                            .map((item) => item.unit!.id)
                            .toList();

                    final consumables = {
                      for (var item in cartItems.where(
                        (item) => item.unit == null,
                      ))
                        item.item.id: item.quantity,
                    };

                    await borrowProvider.createBorrow(
                      borrowDate: borrowDate,
                      returnDate: returnDate,
                      reusableUnits: reusableUnits,
                      consumables: consumables,
                    );

                    cartProvider.clearCart();
                    Navigator.pop(context);
                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text('Peminjaman berhasil dibuat'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e, stacktrace) {
                    debugPrint('Error: $e');
                    debugPrint('Stacktrace: $stacktrace');

                    scaffold.showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                child: const Text(
                  'Konfirmasi Peminjaman',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildItemsSummary(List<CartItem> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Detail Barang:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text('• ${item.item.name}'),
              if (item.unit != null)
                Text(
                  ' (${item.unit!.serialNumber})',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              if (item.unit == null)
                Text(
                  ' (Qty: ${item.quantity})',
                  style: TextStyle(color: Colors.grey[600]),
                ),
            ],
          ),
        );
      }),
    ],
  );
}
