import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';
import 'package:sisfo_sarpras_revisi/views/borrow/borrow_history_page.dart';
import 'package:sisfo_sarpras_revisi/views/cart/cart_page.dart';
import 'package:sisfo_sarpras_revisi/views/home/home_page.dart';
import 'package:sisfo_sarpras_revisi/views/profile/profile_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(), // Tambahkan CartPage di sini
    ProfilePage(),
    BorrowHistoryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda', backgroundColor: Colors.blueAccent),
          // Dalam MainWrapper.dart, modifikasi BottomNavigationBarItem untuk keranjang:
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, _) {
                return Badge(
                  label: cart.items.isEmpty ? null : Text('${cart.totalItems}'),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Peminjaman'),
        ],
      ),
      floatingActionButton:
          _selectedIndex == 0
              ? Consumer<CartProvider>(
                builder: (context, cart, _) {
                  if (cart.items.isEmpty) return const SizedBox();
                  return FloatingActionButton(
                    mini: true,
                    onPressed: () => _onItemTapped(1),
                    child: Badge(
                      label: Text('${cart.totalItems}'),
                      child: const Icon(Icons.shopping_cart),
                    ),
                  );
                },
              )
              : null,
    );
  }
}
