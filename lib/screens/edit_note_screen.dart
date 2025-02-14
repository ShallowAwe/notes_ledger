import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_ledger/model/notes_model.dart';

class EditNoteScreen extends StatefulWidget {
  final NotesModel note;

  const EditNoteScreen({
    super.key,
    required this.note,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);

    _titleController.addListener(_onFieldChanged);
    _contentController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final titleChanged = _titleController.text != widget.note.title;
    final contentChanged = _contentController.text != widget.note.content;

    if (_hasChanges != (titleChanged || contentChanged)) {
      setState(() {
        _hasChanges = titleChanged || contentChanged;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Allows the user to navigate back
      onPopInvoked: (didPop) async {
        if (!didPop) return; // Don't interfere if pop already happened

        bool shouldClose = await _onWillPop(); // Your custom logic

        if (!shouldClose) {
          return; // Prevent popping if the user cancels
        }

        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black, // Match dark theme
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Edit Note',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _hasChanges ? _saveNote : null,
              icon: const Icon(Icons.save, color: Colors.blueAccent),
            ),
            IconButton(
              onPressed: _deleteNote,
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white), // White text
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle:
                        TextStyle(color: Colors.grey.shade400), // Lighter label
                    hintText: 'Enter title...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade600), // Lighter hint
                    filled: true,
                    fillColor: Colors.grey.shade900, // Dark background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Content Field
                Expanded(
                  child: TextFormField(
                    controller: _contentController,
                    style: const TextStyle(color: Colors.white), // White text
                    decoration: InputDecoration(
                      labelText: 'Content',
                      labelStyle: TextStyle(
                          color: Colors.grey.shade400), // Lighter label
                      hintText: 'Write something...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600), // Lighter hint
                      filled: true,
                      fillColor: Colors.grey.shade900, // Dark background
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some content';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900, // Dark background
        title: Text(
          'Discard changes?',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: GoogleFonts.poppins(color: Colors.grey.shade400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL',
                style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DISCARD',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final updatedNote = NotesModel(
        id: widget.note.id,
        title: _titleController.text,
        content: _contentController.text,
        createdAt: DateTime.now(),
      );
      Navigator.pop(context, updatedNote);
    }
  }

  void _deleteNote() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900, // Dark background
        title: Text(
          'Delete note?',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This action cannot be undone.',
          style: GoogleFonts.poppins(color: Colors.grey.shade400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, 'delete');
            },
            child:
                const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
