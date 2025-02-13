import 'dart:ffi';

import 'package:notes_ledger/model/notes_model.dart';

class UsersModel {
  final String name;
  final String mail;
  final Long password;
  final List<NotesModel> notes;

  UsersModel({
    required this.name,
    required this.mail,
    required this.password,
    required this.notes,
  });
}
