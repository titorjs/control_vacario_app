import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../models/venta_queso.dart';
import '../../../../utils/user_session.dart';
import '../../../../strings/constants.dart';

class AddVentaQuesoScreen extends StatefulWidget {
  final VentaQueso? venta;

  const AddVentaQuesoScreen({Key? key, this.venta}) : super(key: key);

  @override
  _AddVentaQuesoScreenState createState() => _AddVentaQuesoScreenState();
}

class _AddVentaQuesoScreenState extends State<AddVentaQuesoScreen> {
  final TextEditingController _initDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _poundsController = TextEditingController();
  final TextEditingController _leftController = TextEditingController();
  String? _selectedFalto; // Para manejar el estado del ComboBox

  @override
void initState() {
  super.initState();
  if (widget.venta != null) {
    _initDateController.text = widget.venta!.ventaQuesoInit;
    _endDateController.text = widget.venta!.ventaQuesoEnd;
    _poundsController.text = widget.venta!.ventaQuesoPounds.toString();
    _leftController.text = widget.venta!.ventaQuesoLeft.toString();
    _selectedFalto = widget.venta!.ventaQuesoFalto.toString(); // Convertir a 'true' o 'false'
  } else {
    _selectedFalto = 'false'; // Valor predeterminado
  }
}


  Future<void> _saveVentaQueso() async {
    final session = UserSession();
    final token = await session.getToken();

    final data = {
      'ventaQuesoInit': _initDateController.text.trim(),
      'ventaQuesoEnd': _endDateController.text.trim(),
      'ventaQuesoPounds': double.parse(_poundsController.text.trim()),
      'ventaQuesoLeft': double.parse(_leftController.text.trim()),
      'ventaQuesoFalto': _selectedFalto == 'true', // Convierte a booleano
    };

    final url = widget.venta == null
        ? '$apiUrl/$apiVersion/venta-queso'
        : '$apiUrl/$apiVersion/venta-queso/${widget.venta!.ventaQuesoId}';

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
            ? 'Añadir Venta de Queso'
            : 'Editar Venta de Queso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _initDateController,
              decoration: const InputDecoration(labelText: 'Fecha Inicial'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _endDateController,
              decoration: const InputDecoration(labelText: 'Fecha Final'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _poundsController,
              decoration: const InputDecoration(labelText: 'Libras Vendidas'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _leftController,
              decoration: const InputDecoration(labelText: 'Libras Restantes'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedFalto,
              decoration: const InputDecoration(labelText: '¿Faltó Producto?'),
              items: const [
                DropdownMenuItem(value: 'true', child: Text('Sí')),
                DropdownMenuItem(value: 'false', child: Text('No')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFalto = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveVentaQueso,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
