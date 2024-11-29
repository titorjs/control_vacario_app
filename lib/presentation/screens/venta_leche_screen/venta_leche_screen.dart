import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../models/venta_leche.dart';
import '../../../../utils/user_session.dart';
import '../../../../strings/constants.dart';
import './add_venta_leche_screen/add_venta_leche_screen.dart';

class VentaLecheScreen extends StatefulWidget {
  const VentaLecheScreen({Key? key}) : super(key: key);

  @override
  _VentaLecheScreenState createState() => _VentaLecheScreenState();
}

class _VentaLecheScreenState extends State<VentaLecheScreen> {
  List<VentaLeche> ventas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVentasLeche();
  }

  Future<void> _fetchVentasLeche() async {
    final session = UserSession();
    final token = await session.getToken();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$apiVersion/venta-leche'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          ventas = data.map((json) => VentaLeche.fromJson(json)).toList()
            ..sort((a, b) => b.ventaLecheraDate.compareTo(a.ventaLecheraDate));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener las ventas de leche')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addVentaLeche() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVentaLecheScreen()),
    ).then((_) => _fetchVentasLeche());
  }

  void _editVentaLeche(VentaLeche venta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVentaLecheScreen(venta: venta),
      ),
    ).then((_) => _fetchVentasLeche());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ventas de Leche')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVentaLeche,
        child: const Icon(Icons.add),
        tooltip: 'Añadir Venta de Leche',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ventas.isEmpty
              ? const Center(child: Text('No hay datos para mostrar.'))
              : ListView.builder(
                  itemCount: ventas.length,
                  itemBuilder: (context, index) {
                    final venta = ventas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          'Fecha: ${venta.ventaLecheraDate}',
                        ),
                        subtitle: Text(
                          'Litros: ${venta.ventaLecheraLiters}\nPrecio por litro: ${venta.ventaLecheraPpl}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editVentaLeche(venta),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
