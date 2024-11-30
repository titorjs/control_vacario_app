import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../utils/user_session.dart';
import '../../../../strings/constants.dart';

class AddProductionTotalScreen extends StatefulWidget {
  @override
  _AddProductionTotalScreenState createState() => _AddProductionTotalScreenState();
}

class _AddProductionTotalScreenState extends State<AddProductionTotalScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _realProductionController = TextEditingController();
  int? _selectedProductId; // ID del producto seleccionado

  Future<void> _saveProduction() async {
    final session = UserSession();
    final token = await session.getToken();

    final data = {
      'id': {
        'producto': {
          'productoId': _selectedProductId, // Usamos el valor seleccionado
        },
        'produccionDate': _dateController.text.trim(),
      },
      'produccionReal': double.parse(_realProductionController.text.trim()),
      'produccionCalculada': 400.0, // Ajustar según la lógica
    };

    final response = await http.post(
      Uri.parse('$apiUrl/$apiVersion/produccion-total'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producción añadida con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Producción Total')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedProductId,
              decoration: const InputDecoration(labelText: 'Producto'),
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Queso'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Leche'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedProductId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _realProductionController,
              decoration: const InputDecoration(labelText: 'Producción Real'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProduction,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
