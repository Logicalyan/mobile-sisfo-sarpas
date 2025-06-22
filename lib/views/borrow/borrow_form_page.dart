import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_sarpras_revisi/core/config.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class BorrowFormPage extends StatefulWidget {
  const BorrowFormPage({super.key});

  @override
  State<BorrowFormPage> createState() => _BorrowFormPageState();
}

class _BorrowFormPageState extends State<BorrowFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _borrowDate;
  DateTime? _returnDate;
  bool _isSubmitting = false;

  Future<void> _submitBorrowRequest(CartProvider cart) async {
    if (!_formKey.currentState!.validate() || _borrowDate == null || _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data form')),
      );
      return;
    }

    final reusableUnits = cart.items
        .where((item) => item.unit != null)
        .map((item) => item.unit!.id)
        .toList();

    final consumables = <String, Map<String, int>>{};
    for (final item in cart.items.where((item) => item.unit == null)) {
      consumables[item.item.id.toString()] = {
        'quantity': item.quantity,
      };
    }

    final payload = {
      'borrow_date': DateFormat('yyyy-MM-dd').format(_borrowDate!),
      'return_date': DateFormat('yyyy-MM-dd').format(_returnDate!),
      'reusable_units': reusableUnits,
      'consumables': consumables,
    };

    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/borrows'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Ganti dengan token loginmu
        },
        body: jsonEncode(payload),
      );

      setState(() => _isSubmitting = false);

      if (response.statusCode == 201) {
        cart.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengajuan peminjaman berhasil')),
        );
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${error['message'] ?? 'Terjadi kesalahan'}')),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isBorrowDate) async {
    final initialDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(initialDate.year + 1),
    );
    if (picked != null) {
      setState(() {
        if (isBorrowDate) {
          _borrowDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Form Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pinjam',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ),
                controller: TextEditingController(
                  text: _borrowDate != null ? DateFormat('dd MMM yyyy').format(_borrowDate!) : '',
                ),
                validator: (_) => _borrowDate == null ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Kembali',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ),
                controller: TextEditingController(
                  text: _returnDate != null ? DateFormat('dd MMM yyyy').format(_returnDate!) : '',
                ),
                validator: (_) => _returnDate == null ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              const Text('Ringkasan Barang yang Dipinjam:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.item.name),
                      subtitle: item.unit != null
                          ? Text('Unit: ${item.unit!.serialNumber}')
                          : Text('Qty: ${item.quantity}'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _submitBorrowRequest(cart),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Kirim Pengajuan'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
