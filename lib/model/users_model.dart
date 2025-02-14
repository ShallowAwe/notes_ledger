import 'package:notes_ledger/model/notes_model.dart';

class UsersModel {
  final String id; // Matching ObjectId from MongoDB
  final String name;
  final String email;
  final String password;
  final List<NotesModel> notes;

  UsersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.notes,
  });

  // Convert JSON to UsersModel
  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['_id'] ?? '', // MongoDB stores ID as _id
      name: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      notes: (json['notes'] as List<dynamic>?)
              ?.map((note) => NotesModel.fromJson(note))
              .toList() ??
          [],
    );
  }

  // Convert UsersModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': name,
      'mail': email,
      'password': password,
      'notes': notes.map((note) => note.toJson()).toList(),
    };
  }
}
