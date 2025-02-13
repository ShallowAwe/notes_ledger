import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
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
        final newId =
            notes.isEmpty ? 1 : notes.map((n) => n.id).reduce(max) + 1;

        final newNote = NotesModel(
          id: newId,
          title: result['title']!,
          content: result['content']!,
        );

        notes.add(newNote);
        filteredNotes = notes;
      });
    }
  }

  void _handleNoteUpdated(NotesModel updatedNote) {
    setState(() {
      final index = notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        notes[index] = updatedNote;
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Notes',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Hello, User 👋',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 20,
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: _filterNotes,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Notes Grid with Dynamic Heights
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
                    child: Text(
                      'No notes found',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomScrollView(
                      slivers: [
                        SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            return NoteCard(
                              note: filteredNotes[index],
                              onNoteUpdated: _handleNoteUpdated,
                              onNoteDeleted: _handleNoteDeleted,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
