// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sisfo_sarpras_revisi/models/borrow_transaction.dart';
// import 'package:sisfo_sarpras_revisi/providers/borrow_provider.dart';

// class BorrowHistoryPage extends StatelessWidget {
//   const BorrowHistoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final borrowProvider = Provider.of<BorrowProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Riwayat Peminjaman'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => borrowProvider.loadBorrowHistory(),
//         child: borrowProvider.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : borrowProvider.transactions.isEmpty
//                 ? const Center(child: Text('Tidak ada riwayat peminjaman'))
//                 : ListView.builder(
//                     itemCount: borrowProvider.transactions.length,
//                     itemBuilder: (context, index) {
//                       final transaction = borrowProvider.transactions[index];
//                       return _buildTransactionCard(transaction);
//                     },
//                   ),
//       ),
//     );
//   }

//   Widget _buildTransactionCard(BorrowTransaction transaction) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       child: ExpansionTile(
//         title: Text(transaction.borrowCode),
//         subtitle: Text(
//           'Status: ${transaction.approvalStatus}',
//           style: TextStyle(
//             color: _getStatusColor(transaction.approvalStatus),
//           ),
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Tanggal Pinjam: ${DateFormat('dd MMM yyyy').format(transaction.borrowDate)}'),
//                 Text('Tanggal Kembali: ${DateFormat('dd MMM yyyy').format(transaction.returnDate)}'),
//                 const SizedBox(height: 16),
//                 if (transaction.detailUnits.isNotEmpty) ...[
//                   const Text('Unit Barang:'),
//                   ...transaction.detailUnits.map((unit) => 
//                     ListTile(
//                       leading: const Icon(Icons.qr_code),
//                       title: Text(unit.serialNumber),
//                     ),
//                   ),
//                 ],
//                 if (transaction.detailConsumables.isNotEmpty) ...[
//                   const Text('Barang Habis Pakai:'),
//                   ...transaction.detailConsumables.map((item) => 
//                     ListTile(
//                       leading: const Icon(Icons.inventory),
//                       title: Text(item.itemName),
//                       trailing: Text('Qty: ${item.quantity}'),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }