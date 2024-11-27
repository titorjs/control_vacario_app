import 'package:control_vacario_app/presentation/screens/cow/add_cow/add_cow_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/cow.dart';
import '../../../utils/user_session.dart';
import '../../../strings/constants.dart';
import '../../../widget/cow_item.dart';

class CowsScreen extends StatefulWidget {
  const CowsScreen({Key? key}) : super(key: key);

  @override
  _CowsScreenState createState() => _CowsScreenState();
}

class _CowsScreenState extends State<CowsScreen> {
  List<Cow> cows = [];

  @override
  void initState() {
    super.initState();
    _fetchCows();
  }

  Future<void> _fetchCows() async {
    final session = UserSession();
    final token = await session.getToken();

    final response = await http.get(
      Uri.parse('$apiUrl/$apiVersion/vacas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> cowJson = json.decode(response.body);
      setState(() {
        cows = cowJson.map((json) => Cow.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar vacas')),
      );
    }
  }

  void _editCow(Cow cow) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCowScreen(cow: cow),
      ),
    ).then((_) => _fetchCows()); // Refresca la lista después de editar
  }

  void _deleteCow(int cowId) async {
    final session = UserSession();
    final token = await session.getToken();

    final response = await http.delete(
      Uri.parse('$apiUrl/$apiVersion/vacas/$cowId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        cows.removeWhere((cow) => cow.id == cowId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vaca eliminada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar vaca')),
      );
    }
  }

  void _addCow() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCowScreen()),
    ).then((_) => _fetchCows()); // Refresca la lista después de agregar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacas'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCows, // Llama a _fetchCows cuando se hace pull-to-refresh
        child: cows.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: cows.length,
                itemBuilder: (context, index) {
                  final cow = cows[index];
                  return CowItem(
                    cow: cow,
                    onEdit: () => _editCow(cow),
                    onDelete: () => _deleteCow(cow.id),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCow,
        child: const Icon(Icons.add),
        tooltip: 'Crear nueva vaca',
      ),
    );
  }
}
