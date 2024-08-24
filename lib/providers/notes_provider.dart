import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../utils/database_helper.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  // This setter is for testing purposes only
  @visibleForTesting
  set dbHelper(DatabaseHelper helper) {
    _dbHelper = helper;
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _notes = await _dbHelper.readAllNotes();
    } catch (e) {
      print('Error loading notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
    try {
      final newNote = await _dbHelper.createNote(note);
      _notes.add(newNote);
      notifyListeners();
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _dbHelper.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _dbHelper.deleteNote(id);
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  Future<String?> backupNotes() async {
    try {
      return await _dbHelper.exportNotes();
    } catch (e) {
      print('Error backing up notes: $e');
      return null;
    }
  }

  Future<bool> restoreNotes(String filePath) async {
    try {
      await _dbHelper.importNotes(filePath);
      await loadNotes();
      return true;
    } catch (e) {
      print('Error restoring notes: $e');
      return false;
    }
  }
}