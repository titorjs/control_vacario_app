import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/user_session.dart';
import '../../../strings/constants.dart';
import './add_total_production/add_production_total_screen.dart';
import './update_total_production/update_production_real_screen.dart';

class ProductionTotalScreen extends StatefulWidget {
  const ProductionTotalScreen({Key? key}) : super(key: key);

  @override
  _ProductionTotalScreenState createState() => _ProductionTotalScreenState();
}

class _ProductionTotalScreenState extends State<ProductionTotalScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _productController = TextEditingController();

  List<dynamic> productions = [];
  List<dynamic> filteredProductions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toIso8601String().split('T')[0]; // Fecha de hoy
    _fetchProductions(_dateController.text);
  }

  Future<void> _fetchProductions(String date) async {
    final session = UserSession();
    final token = await session.getToken();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$apiVersion/produccion-total?date=$date'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          productions = data;
          filteredProductions = data; // Inicialmente, todas las producciones
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener las producciones')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _calculateDailyMilkProduction() async {
    final session = UserSession();
    final token = await session.getToken();

    try {
      final date = _dateController.text.trim();
      final response = await http.get(
        Uri.parse('$apiUrl/$apiVersion/produccion-total/calcular-leche?date=$date'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = utf8.decode(response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al calcular la producción diaria')),
      );
    }
  }


  void _filterProductions() {
    final productFilter = _productController.text.trim().toLowerCase();
    setState(() {
      filteredProductions = productions.where((prod) {
        final productDesc = prod['id']['producto']['productoDesc'].toLowerCase();
        return productDesc.contains(productFilter);
      }).toList();
    });
  }

  void _addProduction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductionTotalScreen()),
    ).then((_) => _fetchProductions(_dateController.text));
  }

  void _updateProduction(dynamic production) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductionRealScreen(production: production),
      ),
    ).then((_) => _fetchProductions(_dateController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Producción Total')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduction,
        child: const Icon(Icons.add),
        tooltip: 'Añadir Producción Total',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    onSubmitted: (value) => _fetchProductions(value),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _fetchProductions(_dateController.text),
                  child: const Text('Cargar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _productController,
              decoration: const InputDecoration(
                labelText: 'Filtrar por Producto',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _filterProductions(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateDailyMilkProduction,
              child: const Text('Calcular Producción Diaria'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : filteredProductions.isEmpty
                    ? const Text('No hay datos para mostrar.')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredProductions.length,
                          itemBuilder: (context, index) {
                            final production = filteredProductions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(
                                  production['id']['producto']['productoDesc'],
                                ),
                                subtitle: Text(
                                  'Producción Real: ${production['produccionReal']} '
                                  '${production['id']['producto']['productoMeasur']}\n'
                                  'Producción Calculada: ${production['produccionCalculada']} '
                                  '${production['id']['producto']['productoMeasur']}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _updateProduction(production),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
