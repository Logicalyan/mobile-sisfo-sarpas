import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_sarpras_revisi/core/config.dart';

class BorrowService {
  static Future<bool> createBorrowTransaction({
    required String borrowDate,
    required String returnDate,
    List<int>? reusableUnits,
    Map<int, int>? consumables,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final Map<String, dynamic> body = {
      'borrow_date': borrowDate,
      'return_date': returnDate,
    };

    if (reusableUnits != null && reusableUnits.isNotEmpty) {
      body['reusable_units'] = reusableUnits;
    }

    if (consumables != null && consumables.isNotEmpty) {
      body['consumables'] = {
        for (var entry in consumables.entries)
          '${entry.key}': {'item_id': entry.key, 'quantity': entry.value}
      };
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/borrows'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  }
}
