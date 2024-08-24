import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:note_taking_app/main.dart';
import 'package:note_taking_app/providers/notes_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesProvider extends Mock implements NotesProvider {}

void main() {
  testWidgets('App should render without crashing', (WidgetTester tester) async {
    final mockNotesProvider = MockNotesProvider();
    when(() => mockNotesProvider.notes).thenReturn([]);
    when(() => mockNotesProvider.isLoading).thenReturn(false);
    when(() => mockNotesProvider.loadNotes()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider<NotesProvider>.value(
        value: mockNotesProvider,
        child: const MyApp(),
      ),
    );

    // Verify that the app renders without crashing
    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets('App should display HomeScreen', (WidgetTester tester) async {
    final mockNotesProvider = MockNotesProvider();
    when(() => mockNotesProvider.notes).thenReturn([]);
    when(() => mockNotesProvider.isLoading).thenReturn(false);
    when(() => mockNotesProvider.loadNotes()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider<NotesProvider>.value(
        value: mockNotesProvider,
        child: const MyApp(),
      ),
    );

    // Verify that the HomeScreen is displayed
    expect(find.text('My Notes'), findsOneWidget);
  });

  testWidgets('App should display loading indicator when isLoading is true', (WidgetTester tester) async {
    final mockNotesProvider = MockNotesProvider();
    when(() => mockNotesProvider.notes).thenReturn([]);
    when(() => mockNotesProvider.isLoading).thenReturn(true);
    when(() => mockNotesProvider.loadNotes()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider<NotesProvider>.value(
        value: mockNotesProvider,
        child: const MyApp(),
      ),
    );

    // Verify that a CircularProgressIndicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}