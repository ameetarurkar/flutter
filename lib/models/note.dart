import 'dart:convert';

class Note {
  final int? id;
  final String title;
  final String content;  // This is now a String to store JSON
  final String category;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,  // Storing JSON string directly
      'category': category,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],  // Retrieving JSON string
      category: map['category'],
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
    );
  }

  // Helper method to get plain text content
  String get plainTextContent {
    try {
      final decodedContent = json.decode(content);
      if (decodedContent is Map && decodedContent.containsKey('ops')) {
        return decodedContent['ops']
            .map((op) => op['insert'])
            .join()
            .trim();
      }
    } catch (e) {
      print('Error decoding note content: $e');
    }
    return content;  // Fallback to raw content if decoding fails
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, category: $category)';
  }
}