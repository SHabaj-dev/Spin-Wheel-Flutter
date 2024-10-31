import 'package:flutter/material.dart';
import 'package:spin_wheel/spin_wheel.dart';

void main() {
  runApp(SpinWheel());
}

class SpinWheel extends StatelessWidget {
  const SpinWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin Wheel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Game(),
    );
  }
}
