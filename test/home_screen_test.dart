import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/providers/notes_provider.dart';
import 'package:note_taking_app/screens/home_screen.dart';

class MockNotesProvider extends Mock implements NotesProvider {}

void main() {
  late MockNotesProvider mockNotesProvider;

  setUp(() {
    mockNotesProvider = MockNotesProvider();
  });

  testWidgets('HomeScreen displays notes correctly',
      (WidgetTester tester) async {
    final testNote = Note(
        id: 1,
        title: 'Test Note',
        content: '{"insert":"Test Content"}',
        category: 'Test');

    when(() => mockNotesProvider.notes).thenReturn([testNote]);
    when(() => mockNotesProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<NotesProvider>.value(
          value: mockNotesProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Test Note'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
  });

  testWidgets('HomeScreen displays loading indicator when isLoading is true',
      (WidgetTester tester) async {
    when(() => mockNotesProvider.notes).thenReturn([]);
    when(() => mockNotesProvider.isLoading).thenReturn(true);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<NotesProvider>.value(
          value: mockNotesProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'HomeScreen displays "No notes yet" message when notes list is empty',
      (WidgetTester tester) async {
    when(() => mockNotesProvider.notes).thenReturn([]);
    when(() => mockNotesProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<NotesProvider>.value(
          value: mockNotesProvider,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('No notes yet. Add a new one!'), findsOneWidget);
  });
}
