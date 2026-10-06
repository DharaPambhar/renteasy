

import 'package:flutter/material.dart';
import 'screens/owner_login.dart';

void main() {
  runApp(const RentEasyApp());
}

class RentEasyApp extends StatelessWidget {
  const RentEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RentEasy',
      home: const ownerlogin(),
    );
  }
}
