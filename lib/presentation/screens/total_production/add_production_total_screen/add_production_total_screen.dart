import 'package:flutter/material.dart';
import '../../../../models/production_total.dart';

class AddProductionTotalScreen extends StatefulWidget {
  final ProductionTotal? production;

  const AddProductionTotalScreen({Key? key, this.production}) : super(key: key);

  @override
  _AddProductionTotalScreenState createState() =>
      _AddProductionTotalScreenState();
}

class _AddProductionTotalScreenState extends State<AddProductionTotalScreen> {
  final TextEditingController _realProductionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.production != null) {
      _realProductionController.text =
          widget.production!.produccionReal.toString();
    }
  }

  Future<void> _saveProduction() async {
    // Implement the logic for saving or updating production
    print('Producción guardada: ${_realProductionController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.production == null ? 'Agregar Producción' : 'Editar Producción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _realProductionController,
              decoration: const InputDecoration(
                labelText: 'Producción Real',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProduction,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
