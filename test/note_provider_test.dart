import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/notes_provider.dart';
import 'package:note_taking_app/utils/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  group('NotesProvider', () {
    late NotesProvider notesProvider;
    late MockDatabaseHelper mockDatabaseHelper;

    setUp(() {
      mockDatabaseHelper = MockDatabaseHelper();
      notesProvider = NotesProvider();
      notesProvider.dbHelper = mockDatabaseHelper;
    });

    test('addNote should add a note to the list', () async {
      final note = Note(
          title: 'Test Note',
          content: '{"ops":[{"insert":"Test Content\\n"}]}',
          category: 'Test');
      when(() => mockDatabaseHelper.createNote(any()))
          .thenAnswer((_) async => note.copyWith(id: 1));

      await notesProvider.addNote(note);

      expect(notesProvider.notes.length, 1);
      expect(notesProvider.notes.first.title, 'Test Note');
      expect(notesProvider.notes.first.plainTextContent, 'Test Content\n');
    });

    test('updateNote should update an existing note', () async {
      final originalNote = Note(
          id: 1,
          title: 'Original',
          content: '{"ops":[{"insert":"Original Content\\n"}]}',
          category: 'Test');
      final updatedNote = originalNote.copyWith(
          title: 'Updated',
          content: '{"ops":[{"insert":"Updated Content\\n"}]}');

      // Add the original note using the addNote method
      when(() => mockDatabaseHelper.createNote(any()))
          .thenAnswer((_) async => originalNote);
      await notesProvider.addNote(originalNote);

      // Now set up the mock for updateNote
      when(() => mockDatabaseHelper.updateNote(any()))
          .thenAnswer((_) async => 1);

      // Perform the update
      await notesProvider.updateNote(updatedNote);

      expect(notesProvider.notes.length, 1);
      expect(notesProvider.notes.first.title, 'Updated');
      expect(notesProvider.notes.first.plainTextContent, 'Updated Content\n');
    });

    test('deleteNote should remove a note from the list', () async {
      final note = Note(
          id: 1,
          title: 'Test Note',
          content: '{"ops":[{"insert":"Test Content\\n"}]}',
          category: 'Test');

      // Add the note using the addNote method
      when(() => mockDatabaseHelper.createNote(any()))
          .thenAnswer((_) async => note);
      await notesProvider.addNote(note);

      // Set up the mock for deleteNote
      when(() => mockDatabaseHelper.deleteNote(1)).thenAnswer((_) async => 1);

      // Perform the delete
      await notesProvider.deleteNote(1);

      expect(notesProvider.notes.length, 0);
    });

    test('loadNotes should populate the notes list', () async {
      final testNotes = [
        Note(
            id: 1,
            title: 'Note 1',
            content: '{"ops":[{"insert":"Content 1\\n"}]}',
            category: 'Test'),
        Note(
            id: 2,
            title: 'Note 2',
            content: '{"ops":[{"insert":"Content 2\\n"}]}',
            category: 'Test'),
      ];
      when(() => mockDatabaseHelper.readAllNotes())
          .thenAnswer((_) async => testNotes);

      await notesProvider.loadNotes();

      expect(notesProvider.notes.length, 2);
      expect(notesProvider.notes[0].title, 'Note 1');
      expect(notesProvider.notes[1].title, 'Note 2');
    });
  });
}
