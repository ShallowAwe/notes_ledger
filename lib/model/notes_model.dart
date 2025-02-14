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
    return NotesModel(
      id: json['_id'], // Use the MongoDB-generated ObjectId
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Keep this field as _id to match MongoDB
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
