import 'package:flutter/material.dart';
import '../../models/cow.dart';

class CowItem extends StatelessWidget {
  final Cow cow;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CowItem({
    Key? key,
    required this.cow,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(child: Text(cow.code)), // Muestra el código de la vaca
        title: Text(cow.name),
        subtitle: Text('${cow.description}\nTipo: ${cow.type.description} | Estado: ${cow.status.description}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
