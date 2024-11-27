import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/production_total.dart';
import '../../../utils/user_session.dart';
import '../../../strings/constants.dart';
import './add_production_total_screen/add_production_total_screen.dart';

class ProductionTotalScreen extends StatefulWidget {
  const ProductionTotalScreen({Key? key}) : super(key: key);

  @override
  _ProductionTotalScreenState createState() => _ProductionTotalScreenState();
}

class _ProductionTotalScreenState extends State<ProductionTotalScreen> {
  List<ProductionTotal> productions = [];

  @override
  void initState() {
    super.initState();
    _fetchProductions();
  }

  Future<void> _fetchProductions() async {
    final session = UserSession();
    final token = await session.getToken();

    final response = await http.get(
      Uri.parse('$apiUrl/$apiVersion/produccion-total?date=2024-11-17'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> productionJson = json.decode(response.body);
      setState(() {
        productions = productionJson
            .map((json) => ProductionTotal.fromJson(json))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar las producciones')),
      );
    }
  }

  void _editProduction(ProductionTotal production) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductionTotalScreen(production: production),
      ),
    ).then((_) => _fetchProductions());
  }

  void _deleteProduction(ProductionTotal production) async {
    final session = UserSession();
    final token = await session.getToken();

    final response = await http.delete(
      Uri.parse(
        '$apiUrl/$apiVersion/produccion-total/actualizar-produccion-real',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        productions.removeWhere(
            (prod) => prod.productoId == production.productoId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producción eliminada con éxito')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar producción')),
      );
    }
  }

  void _addProduction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductionTotalScreen()),
    ).then((_) => _fetchProductions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producción Total'),
      ),
      body: productions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productions.length,
              itemBuilder: (context, index) {
                final production = productions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(production.productoNombre),
                    subtitle: Text(
                        'Fecha: ${production.produccionDate}\nProducción Real: ${production.produccionReal} L'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editProduction(production),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProduction(production),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduction,
        child: const Icon(Icons.add),
        tooltip: 'Agregar Producción',
      ),
    );
  }
}
