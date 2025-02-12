import 'package:notes_ledger/model/notes_model.dart';

final List<NotesModel> dummyNotes = [
  NotesModel(
    id: 1,
    title: "Shopping List",
    content:
        "1. Milk\n2. Bread\n3. Eggs\n4.Milk\n2. Bread\n3. Eggs\n4.Milk\n2. Bread\n3. Eggs\n4.Milk\n2. Bread\n3. Eggs\n4.Milk\n2. Bread\n3. Eggs\n4.Milk\n2. Bread\n3. Eggs\n4. Vegetables",
  ),
  NotesModel(
    id: 2,
    title: "Meeting Notes",
    content: "Discuss project timeline\nAssign tasks\nSet next meeting date",
  ),
  NotesModel(
    id: 3,
    title: "Ideas",
    content: "App feature ideas:\n- Dark mode\n- Cloud sync\n- Categories",
  ),
  NotesModel(
    id: 4,
    title: "To-Do",
    content: "- Email client\n- Call dentist\n- Fix bug in code",
  ),
];
