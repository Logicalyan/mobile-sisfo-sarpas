import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_sarpras_revisi/core/config.dart';
import 'package:sisfo_sarpras_revisi/models/category.dart';
import 'package:sisfo_sarpras_revisi/models/item.dart';
import 'package:sisfo_sarpras_revisi/models/item_unit.dart';

class ItemService {
  // Add to ItemService
  Future<List<Category>> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/categories'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories');
  }

  Future<List<Item>> fetchItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/items'), // ganti jika endpoint beda
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data barang');
    }
  }

  Future<List<ItemUnit>> fetchUnitsByItemId(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/units'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // Sesuaikan dengan format Laravel apiResponse
      final List data = body is Map ? body['data'] ?? [] : [];

      print('Parsed data: ${data.length} items');

      return data
          .where((e) => e != null && e['item_id'] == itemId)
          .map<ItemUnit>((e) => ItemUnit.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load units: ${response.statusCode}');
  }

  Future<List<Map<String, dynamic>>> fetchAllUnitsRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/units'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).whereType<Map<String, dynamic>>().toList();
    } else {
      throw Exception('Gagal memuat item units');
    }
  }
}
