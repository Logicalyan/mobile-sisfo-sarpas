import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sisfo_sarpras_revisi/providers/borrow_provider.dart';
import 'package:sisfo_sarpras_revisi/providers/cart_provider.dart';
import 'package:sisfo_sarpras_revisi/providers/item_provider.dart';
import 'views/splash/splash_page.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BorrowProvider()),
      ],
      child: const SarprasApp(),
    ),
  );
}

class SarprasApp extends StatelessWidget {
  const SarprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sisfo Sarpras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashPage(), // mulai dari splash
    );
  }
}
