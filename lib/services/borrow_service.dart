import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_sarpras_revisi/core/config.dart';
import 'package:sisfo_sarpras_revisi/models/borrow_transaction.dart';

class BorrowService {
  Future<List<BorrowTransaction>> getBorrowHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/borrows'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => BorrowTransaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load borrow history');
    }
  }

  Future<BorrowTransaction> createBorrow({
    required DateTime borrowDate,
    required DateTime returnDate,
    required List<int> reusableUnits,
    required Map<int?, int> consumables,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print("Payload: ${jsonEncode({
      'borrow_date': borrowDate.toIso8601String(),
      'return_date': returnDate.toIso8601String(),
      'reusable_units': reusableUnits,
      'consumables': consumables.entries.map((e) => {'item_id': e.key, 'quantity': e.value}).toList(),
    })}");
    
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/borrows'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'borrow_date': borrowDate.toIso8601String(),
        'return_date': returnDate.toIso8601String(),
        'reusable_units': reusableUnits,
        'consumables': consumables.entries
            .map((e) => {'item_id': e.key, 'quantity': e.value})
            .toList(),
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return BorrowTransaction.fromJson(json.decode(response.body)['data']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to create borrow transaction');
    }
  }
}