import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'dart:convert';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleController;
  late quill.QuillController _contentController;
  String _selectedCategory = 'Personal';
  final FocusNode _editorFocusNode = FocusNode();

  final List<String> _categories = ['Personal', 'Work', 'Study', 'Other'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = quill.QuillController(
      document: widget.note != null
          ? quill.Document.fromJson(jsonDecode(widget.note!.content))
          : quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _selectedCategory = widget.note?.category ?? 'Personal';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            quill.QuillToolbar.simple(
              configurations: quill.QuillSimpleToolbarConfigurations(
                controller: _contentController,
                sharedConfigurations: quill.QuillSharedConfigurations(
                  locale: Localizations.localeOf(context),
                ),
              ),
            ),
            Expanded(
              child: quill.QuillEditor(
                configurations: quill.QuillEditorConfigurations(
                  controller: _contentController,
                  placeholder: 'Add content...',
                  scrollable: true,
                  autoFocus: false,
                  padding: const EdgeInsets.all(0),
                  expands: true,
                ),
                focusNode: _editorFocusNode,
                scrollController: ScrollController(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = jsonEncode(_contentController.document.toDelta().toJson());

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    if (widget.note == null) {
      final newNote =
          Note(title: title, content: content, category: _selectedCategory);
      notesProvider.addNote(newNote);
    } else {
      final updatedNote = widget.note!.copyWith(
          title: title, content: content, category: _selectedCategory);
      notesProvider.updateNote(updatedNote);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }
}
