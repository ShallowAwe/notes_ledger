import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_ledger/data/dummy_data.dart';
import 'package:notes_ledger/model/notes_model.dart';
import 'package:notes_ledger/screens/add_notes.dart';
import 'package:notes_ledger/widgets/note_card.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<NotesModel> notes = dummyNotes;
  List<NotesModel> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _addNewNote() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const AddNoteScreen()),
    );

    if (result != null) {
      setState(() {
        // Generate a new ID (you might want to use UUID or another method)
        final newId =
            notes.isEmpty ? 1 : notes.map((n) => n.id).reduce(max) + 1;

        final newNote = NotesModel(
          id: newId,
          title: result['title']!,
          content: result['content']!,
        );

        notes.add(newNote);
        // Refresh filtered notes if no search is active
        if (filteredNotes.length == notes.length - 1) {
          filteredNotes = notes;
        }
      });
    }
  }

  void _handleNoteUpdated(NotesModel updatedNote) {
    setState(() {
      final index = notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        notes[index] = updatedNote;

        // Update filtered notes if the updated note is present
        final filteredIndex =
            filteredNotes.indexWhere((note) => note.id == updatedNote.id);
        if (filteredIndex != -1) {
          filteredNotes[filteredIndex] = updatedNote;
        }
      }
    });
  }

  void _handleNoteDeleted(NotesModel deletedNote) {
    setState(() {
      notes.removeWhere((note) => note.id == deletedNote.id);
      filteredNotes.removeWhere((note) => note.id == deletedNote.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              notes.add(deletedNote);
              // Re-apply current filter
              _filterNotes('');
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Hello user',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.blueGrey,
                    fontSize: 22,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: _filterNotes,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
                    child: Text(
                      'No notes found',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      return NoteCard(
                        note: filteredNotes[index],
                        onNoteUpdated: _handleNoteUpdated,
                        onNoteDeleted: _handleNoteDeleted,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewNote,
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
