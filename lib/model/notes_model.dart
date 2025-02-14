class NotesModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    try {
      // Handle the nested id structure
      String noteId;
      if (json['id'] is Map) {
        // Use timestamp as id since that's unique
        noteId = json['id']['timestamp'].toString();
      } else {
        noteId = json['id'].toString();
      }

      return NotesModel(
        id: noteId,
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
      );
    } catch (e) {
      print('Error parsing note: $json');
      print('Error details: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
