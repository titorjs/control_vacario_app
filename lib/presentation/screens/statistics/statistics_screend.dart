import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/user_session.dart';
import '../../../strings/constants.dart';

class ProductionStatsScreen extends StatefulWidget {
  const ProductionStatsScreen({Key? key}) : super(key: key);

  @override
  _ProductionStatsScreenState createState() => _ProductionStatsScreenState();
}

class _ProductionStatsScreenState extends State<ProductionStatsScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Llave para el Formulario
  List<String> recommendations = [];
  bool _isLoading = false;

  // Validar formato de fecha
  String? _validateDate(String? value) {
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    if (!dateRegex.hasMatch(value)) {
      return 'La fecha debe estar en formato YYYY-MM-DD';
    }
    return null;
  }

  Future<void> _fetchRecommendations() async {
    if (!_formKey.currentState!.validate()) {
      // Detener si el formulario no es válido
      return;
    }

    final session = UserSession();
    final token = await session.getToken();

    setState(() {
      _isLoading = true;
    });

    final startDate = _startDateController.text.trim();
    final endDate = _endDateController.text.trim();
    final url = Uri.parse('$apiUrl/$apiVersion/stats/production/$startDate/$endDate');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> rawRecommendations = data['recomendaciones'];

        setState(() {
          recommendations = rawRecommendations.values.cast<String>().toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener las recomendaciones')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recomendaciones de Producción')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de inicio (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: _validateDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de fin (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: _validateDate,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchRecommendations,
                child: const Text('Mostrar'),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : recommendations.isEmpty
                      ? const Text('No hay recomendaciones para mostrar')
                      : Expanded(
                          child: ListView.builder(
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final initDate = DateTime.parse(_startDateController.text.trim());
                              final recommendationDate = initDate.add(Duration(days: index * 7));
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text((index + 1).toString()),
                                ),
                                title: Text(
                                  'Semana del ${recommendationDate.toIso8601String().split('T')[0]}:',
                                ),
                                subtitle: Text(recommendations[index]),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
