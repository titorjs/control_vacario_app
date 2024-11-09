import 'package:flutter/material.dart';
import '../../models/remedy.dart';

class RemedyItem extends StatelessWidget {
  final Remedy remedy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RemedyItem({
    Key? key,
    required this.remedy,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(remedy.name),
        subtitle: Text(remedy.description),
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
