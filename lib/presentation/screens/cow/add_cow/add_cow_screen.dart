import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../models/cow.dart';
import '../../../../utils/user_session.dart';
import '../../../../strings/constants.dart';

class AddCowScreen extends StatefulWidget {
  final Cow? cow; // Parámetro opcional para edición

  const AddCowScreen({Key? key, this.cow}) : super(key: key);

  @override
  _AddCowScreenState createState() => _AddCowScreenState();
}

class _AddCowScreenState extends State<AddCowScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedType = 1; // Valor predeterminado
  int _selectedStatus = 1; // Valor predeterminado

  @override
  void initState() {
    super.initState();
    if (widget.cow != null) {
      // Si estamos editando, cargamos los datos de la vaca existente
      _codeController.text = widget.cow!.code;
      _nameController.text = widget.cow!.name;
      _descriptionController.text = widget.cow!.description;
      _selectedType = widget.cow!.type.id;
      _selectedStatus = widget.cow!.status.id;
    }
  }

  Future<void> _saveCow() async {
    final session = UserSession();
    final token = await session.getToken();

    final url = widget.cow == null
        ? Uri.parse('$apiUrl/$apiVersion/vacas') // Endpoint de creación
        : Uri.parse('$apiUrl/$apiVersion/vacas/${widget.cow!.id}'); // Endpoint de edición

    final bodyRequest = jsonEncode({
            "code": _codeController.text,
            "name": _nameController.text,
            "description": _descriptionController.text,
            "typeId": _selectedType,
            "statusId": _selectedStatus,
          });

    final response = await (widget.cow == null
        ? http.post(url, headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }, body: bodyRequest )
        : http.put(url, headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }, body: bodyRequest));

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.cow == null ? 'Vaca creada con éxito' : 'Vaca actualizada con éxito')),
      );
      Navigator.pop(context); // Vuelve a la pantalla anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al ${widget.cow == null ? 'crear' : 'actualizar'} la vaca')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cow == null ? 'Agregar Vaca' : 'Editar Vaca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Código'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedType,
              items: [
                DropdownMenuItem(value: 1, child: Text('BROWNSWISS')),
                DropdownMenuItem(value: 2, child: Text('PINTADA')),
                DropdownMenuItem(value: 3, child: Text('HORSEY')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Tipo'),
            ),
            DropdownButtonFormField<int>(
              value: _selectedStatus,
              items: [
                DropdownMenuItem(value: 1, child: Text('PRODUCCION')),
                DropdownMenuItem(value: 2, child: Text('SECA')),
                DropdownMenuItem(value: 3, child: Text('MUERTA')),
                DropdownMenuItem(value: 4, child: Text('VENDIDA')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Estado'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCow,
              child: Text(widget.cow == null ? 'Aceptar' : 'Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
