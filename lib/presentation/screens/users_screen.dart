import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user.dart';
import '../../utils/user_session.dart';
import '../../widget/user_item.dart';
import '../../strings/constants.dart';
import 'add_user_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final session = UserSession();
    final token = await session.getToken(); // Obtén el token JWT

    final response = await http.get(
      Uri.parse('$apiUrl/$apiVersion/users'),
      headers: {
        'Authorization': 'Bearer $token', // Añade el Bearer Token en el encabezado
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      setState(() {
        users = userJson.map((json) => User.fromJson(json)).toList();
      });
    } else {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar usuarios')),
      );
    }
  }

  void _editUser(User user) {
    // Implementa la lógica de edición
    print('Editar usuario: ${user.username}');
  }

  Future<void> _deleteUser(int userId) async {
  final session = UserSession();
  final token = await session.getToken(); // Obtiene el token JWT

  final response = await http.delete(
    Uri.parse('$apiUrl/$apiVersion/users/$userId'),
    headers: {
      'Authorization': 'Bearer $token', // Añade el Bearer Token en el encabezado
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Elimina el usuario de la lista local solo si la llamada fue exitosa
    setState(() {
      users.removeWhere((user) => user.id == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario eliminado con éxito')),
    );
  } else {
    // Manejo de errores: muestra un mensaje de error si la eliminación falla
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al eliminar usuario')),
    );
  }
}

  void _addUser() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddUserScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserItem(
                  user: user,
                  onEdit: () => _editUser(user),
                  onDelete: () => _deleteUser(user.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        tooltip: 'Agregar nuevo usuario',
        child: const Icon(Icons.add),
      ),
    );
  }
}
