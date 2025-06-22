// import 'package:flutter/material.dart';
// import 'package:sisfo_sarpras_revisi/models/borrow_transaction.dart';
// import 'package:sisfo_sarpras_revisi/services/borrow_service.dart';

// class BorrowProvider with ChangeNotifier {
//   final BorrowService _borrowService = BorrowService();
//   List<BorrowTransaction> _transactions = [];
//   bool _isLoading = false;

//   List<BorrowTransaction> get transactions => _transactions;
//   bool get isLoading => _isLoading;

//   Future<void> loadBorrowHistory() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       _transactions = await _borrowService.getBorrowHistory();
//     } catch (e) {
//       debugPrint('Error loading borrow history: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<BorrowTransaction> createBorrow({
//     required DateTime borrowDate,
//     required DateTime returnDate,
//     required List<int> reusableUnits,
//     required Map<int?,int> consumables,
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final transaction = await _borrowService.createBorrow(
//         borrowDate: borrowDate,
//         returnDate: returnDate,
//         reusableUnits: reusableUnits,
//         consumables: consumables,
//       );
      
//       _transactions.insert(0, transaction);
//       return transaction;
//     } catch (e) {
//       debugPrint('Error creating borrow: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }