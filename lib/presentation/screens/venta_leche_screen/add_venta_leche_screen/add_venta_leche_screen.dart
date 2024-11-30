import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../models/venta_leche.dart';
import '../../../../utils/user_session.dart';
import '../../../../strings/constants.dart';

class AddVentaLecheScreen extends StatefulWidget {
  final VentaLeche? venta;

  const AddVentaLecheScreen({Key? key, this.venta}) : super(key: key);

  @override
  _AddVentaLecheScreenState createState() => _AddVentaLecheScreenState();
}

class _AddVentaLecheScreenState extends State<AddVentaLecheScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  final TextEditingController _pplController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.venta != null) {
      _dateController.text = widget.venta!.ventaLecheraDate;
      _litersController.text = widget.venta!.ventaLecheraLiters.toString();
      _pplController.text = widget.venta!.ventaLecheraPpl.toString();
    }
  }

  Future<void> _saveVentaLeche() async {
    final session = UserSession();
    final token = await session.getToken();

    final data = {
      'ventaLecheraDate': _dateController.text.trim(),
      'ventaLecheraLiters': double.parse(_litersController.text.trim()),
      'ventaLecheraPpl': double.parse(_pplController.text.trim()),
    };

    final url = widget.venta == null
        ? '$apiUrl/$apiVersion/venta-leche'
        : '$apiUrl/$apiVersion/venta-leche/${widget.venta!.ventaLecheraDate}';

    final response = widget.venta == null
        ? await http.post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode(data),
          )
        : await http.put(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode(data),
          );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.venta == null
            ? 'Venta añadida con éxito'
            : 'Venta actualizada con éxito')),
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
      appBar: AppBar(
        title: Text(widget.venta == null
            ? 'Añadir Venta de Leche'
            : 'Editar Venta de Leche'),
      ),
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
            TextField(
              controller: _litersController,
              decoration: const InputDecoration(labelText: 'Litros Vendidos'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pplController,
              decoration: const InputDecoration(labelText: 'Precio por litro'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveVentaLeche,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
