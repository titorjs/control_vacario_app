import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/user_session.dart';
import '../../strings/constants.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  DateTime? _birthDate;
  String _role = 'ROLE_USER'; // Valor predeterminado para el rol

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _registerUser() async {
    final session = UserSession();
    final token = await session.getToken();

    final response = await http.post(
      Uri.parse('$apiUrl/$apiVersion/users/register'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username": _usernameController.text,
        "password": _passwordController.text,
        "role": _role,
        "name": _nameController.text,
        "lastname": _lastnameController.text,
        "birth": _birthDate?.toIso8601String().split('T')[0], // Formato YYYY-MM-DD
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario creado con éxito')),
      );
      Navigator.pop(context); // Vuelve a la pantalla anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _lastnameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _birthDate != null
                      ? 'Fecha de Nacimiento: ${_birthDate!.toLocal()}'.split(' ')[0]
                      : 'Seleccione Fecha de Nacimiento',
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectBirthDate(context),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _role,
              items: [
                DropdownMenuItem(value: 'ROLE_USER', child: Text('Usuario')),
                DropdownMenuItem(value: 'ROLE_ADMIN', child: Text('Administrador')),
              ],
              onChanged: (value) {
                setState(() {
                  _role = value ?? 'ROLE_USER';
                });
              },
              decoration: InputDecoration(labelText: 'Rol'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
