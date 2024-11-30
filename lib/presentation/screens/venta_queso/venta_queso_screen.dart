import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/venta_queso.dart';
import '../../../utils/user_session.dart';
import '../../../strings/constants.dart';
import './add_venta_queso_screen/add_venta_queso_screen.dart';

class VentaQuesoScreen extends StatefulWidget {
  const VentaQuesoScreen({Key? key}) : super(key: key);

  @override
  _VentaQuesoScreenState createState() => _VentaQuesoScreenState();
}

class _VentaQuesoScreenState extends State<VentaQuesoScreen> {
  List<VentaQueso> ventas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVentasQueso();
  }

  Future<void> _fetchVentasQueso() async {
  final session = UserSession();
  final token = await session.getToken();

  setState(() {
    _isLoading = true;
  });

  try {
    final response = await http.get(
      Uri.parse('$apiUrl/$apiVersion/venta-queso'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        ventas = data.map((json) => VentaQueso.fromJson(json)).toList()
          ..sort((a, b) => b.ventaQuesoId.compareTo(a.ventaQuesoId)); // Orden descendente
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al obtener las ventas de queso')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  void _addVentaQueso() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddVentaQuesoScreen()),
    ).then((_) => _fetchVentasQueso());
  }

  void _editVentaQueso(VentaQueso venta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVentaQuesoScreen(venta: venta),
      ),
    ).then((_) => _fetchVentasQueso());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ventas de Queso')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVentaQueso,
        child: const Icon(Icons.add),
        tooltip: 'Añadir Venta de Queso',
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
          'Venta ID: ${venta.ventaQuesoId} - ${venta.ventaQuesoInit} a ${venta.ventaQuesoEnd}',
        ),
        subtitle: Text(
          'Libras Vendidas: ${venta.ventaQuesoPounds}\n'
          'Libras Restantes: ${venta.ventaQuesoLeft}\n'
          'Faltó Producto: ${venta.ventaQuesoFalto ? "Sí" : "No"}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editVentaQueso(venta),
        ),
      ),
    );
  },
));
    
  }
}
