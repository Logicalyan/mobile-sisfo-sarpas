import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';
import 'package:sisfo_sarpras_revisi/views/borrow/borrow_form_page.dart';
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
    BorrowFormPage(),
    ProfilePage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Peminjaman'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
