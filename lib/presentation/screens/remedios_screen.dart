import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/remedy.dart';
import '../../utils/user_session.dart';
import '../../strings/constants.dart';
import '../../widget/remedy_item.dart';
import 'add_remedy_screen.dart';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({Key? key}) : super(key: key);

  @override
  _RemediesScreenState createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  List<Remedy> remedies = [];

  @override
  void initState() {
    super.initState();
    _fetchRemedies();
  }

  Future<void> _fetchRemedies() async {
    final session = UserSession();
    final token = await session.getToken();

    final response = await http.get(
      Uri.parse('$apiUrl/$apiVersion/remedios'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> remedyJson = json.decode(response.body);
      setState(() {
        remedies = remedyJson.map((json) => Remedy.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar remedios')),
      );
    }
  }

  void _editRemedy(Remedy remedy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRemedyScreen(remedy: remedy),
      ),
    ).then((_) => _fetchRemedies());
  }

  void _deleteRemedy(int remedyId) async {
    final session = UserSession();
    final token = await session.getToken();

    final response = await http.delete(
      Uri.parse('$apiUrl/$apiVersion/remedios/$remedyId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        remedies.removeWhere((remedy) => remedy.id == remedyId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Remedio eliminado con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar remedio')),
      );
    }
  }

  void _addRemedy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRemedyScreen()),
    ).then((_) => _fetchRemedies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remedios'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRemedies,
        child: remedies.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: remedies.length,
                itemBuilder: (context, index) {
                  final remedy = remedies[index];
                  return RemedyItem(
                    remedy: remedy,
                    onEdit: () => _editRemedy(remedy),
                    onDelete: () => _deleteRemedy(remedy.id),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRemedy,
        child: const Icon(Icons.add),
        tooltip: 'Crear nuevo remedio',
      ),
    );
  }
}
