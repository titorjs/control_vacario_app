import 'package:flutter/material.dart';

class CowsScreen extends StatelessWidget {
  const CowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacas'),
      ),
      body: const Center(
        child: Text('Aquí irá la pantalla de Vacas'),
      ),
    );
  }
}
