import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import 'note_screen.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: NoteSearch(
                  Provider.of<NotesProvider>(context, listen: false).notes),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'backup') {
                await _backupNotes(context);
              } else if (value == 'restore') {
                await _restoreNotes(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'backup',
                child: Text('Backup Notes'),
              ),
              const PopupMenuItem<String>(
                value: 'restore',
                child: Text('Restore Notes'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notesProvider.notes.isEmpty) {
            return const Center(child: Text('No notes yet. Add a new one!'));
          }
          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return NoteCard(
                note: note,
                onTap: () => _editNote(context, note),
                onDelete: () => _deleteNote(context, note.id!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addNote(context),
      ),
    );
  }

  void _addNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteScreen()),
    );
  }

  void _editNote(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note: note)),
    );
  }

  void _deleteNote(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Provider.of<NotesProvider>(context, listen: false).deleteNote(id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _backupNotes(BuildContext context) async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final backupPath = await notesProvider.backupNotes();
    if (backupPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notes backed up to: $backupPath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to backup notes')),
      );
    }
  }

  Future<void> _restoreNotes(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.single;
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      final success = await notesProvider.restoreNotes(file.path!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notes restored successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to restore notes')),
        );
      }
    }
  }
}

class NoteSearch extends SearchDelegate<Note?> {
  final List<Note> notes;

  NoteSearch(this.notes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return ListTile(
          title: Text(note.title),
          subtitle:
              Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {
            close(context, note);
          },
        );
      },
    );
  }
}
