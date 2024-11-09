import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/remedy.dart';
import '../../utils/user_session.dart';
import '../../strings/constants.dart';

class AddRemedyScreen extends StatefulWidget {
  final Remedy? remedy;

  const AddRemedyScreen({Key? key, this.remedy}) : super(key: key);

  @override
  _AddRemedyScreenState createState() => _AddRemedyScreenState();
}

class _AddRemedyScreenState extends State<AddRemedyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.remedy != null) {
      _nameController.text = widget.remedy!.name;
      _descriptionController.text = widget.remedy!.description;
    }
  }

  Future<void> _saveRemedy() async {
    final session = UserSession();
    final token = await session.getToken();

    final url = widget.remedy == null
        ? Uri.parse('$apiUrl/$apiVersion/remedios')
        : Uri.parse('$apiUrl/$apiVersion/remedios/${widget.remedy!.id}');

    final response = await (widget.remedy == null
        ? http.post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "remedioName": _nameController.text,
              "remedioDesc": _descriptionController.text,
            }),
          )
        : http.put(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "remedioName": _nameController.text,
              "remedioDesc": _descriptionController.text,
            }),
          ));

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.remedy == null
                ? 'Remedio creado con éxito'
                : 'Remedio actualizado con éxito')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al ${widget.remedy == null ? 'crear' : 'actualizar'} el remedio')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.remedy == null ? 'Agregar Remedio' : 'Editar Remedio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre del Remedio'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción del Remedio'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveRemedy,
              child: Text(widget.remedy == null ? 'Aceptar' : 'Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
