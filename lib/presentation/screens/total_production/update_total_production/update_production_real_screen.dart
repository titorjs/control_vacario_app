import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../utils/user_session.dart';
import '../../../../strings/constants.dart';

class UpdateProductionRealScreen extends StatefulWidget {
  final dynamic production;

  const UpdateProductionRealScreen({Key? key, required this.production}) : super(key: key);

  @override
  _UpdateProductionRealScreenState createState() => _UpdateProductionRealScreenState();
}

class _UpdateProductionRealScreenState extends State<UpdateProductionRealScreen> {
  final TextEditingController _realProductionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _realProductionController.text = widget.production['produccionReal'].toString();
  }

  Future<void> _updateProduction() async {
    final session = UserSession();
    final token = await session.getToken();

    final data = {
      'productoId': widget.production['id']['producto']['productoId'],
      'produccionDate': widget.production['id']['produccionDate'],
      'nuevaProduccionReal': double.parse(_realProductionController.text.trim()),
    };

    final response = await http.put(
      Uri.parse('$apiUrl/$apiVersion/produccion-total/actualizar-produccion-real'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producción actualizada con éxito')),
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
      appBar: AppBar(title: const Text('Actualizar Producción Real')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _realProductionController,
              decoration: const InputDecoration(labelText: 'Producción Real'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateProduction,
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
