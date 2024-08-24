import 'package:flutter/material.dart';
import '../models/note.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final document = quill.Document.fromJson(jsonDecode(note.content));
    final plainText = document.toPlainText();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plainText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Chip(
              label: Text(note.category),
              backgroundColor: _getCategoryColor(note.category),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return Colors.blue.shade100;
      case 'work':
        return Colors.green.shade100;
      case 'study':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
