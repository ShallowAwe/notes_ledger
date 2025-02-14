import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:notes_ledger/model/notes_model.dart';
import 'package:notes_ledger/screens/add_notes.dart';
import 'package:notes_ledger/widgets/note_card.dart';
import 'package:uuid/uuid.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen(
      {super.key, required this.token, required this.username});

  final String token;
  final String username;

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen>
    with SingleTickerProviderStateMixin {
  final List<NotesModel> notes = [];
  List<NotesModel> filteredNotes = [];
  bool isLoading = true;
  String? errorMessage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fetchNotes();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final url =
        Uri.parse('http://10.0.2.2:8080/user/${widget.username}/notesFetch');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final parsedNotes = jsonResponse
            .map((noteJson) {
              try {
                return NotesModel.fromJson(noteJson);
              } catch (e) {
                _showError('Error parsing note data');
                return null;
              }
            })
            .where((note) => note != null)
            .cast<NotesModel>()
            .toList();

        setState(() {
          notes.clear();
          notes.addAll(parsedNotes);
          filteredNotes = List.from(notes);
          isLoading = false;
        });

        _fadeController.reset();
        _fadeController.forward();
      } else {
        setState(() {
          errorMessage = 'Unable to fetch notes. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error. Please check your connection.';
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddNoteScreen(
          token: widget.token,
          username: widget.username,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );

    if (result != null) {
      // First update UI immediately
      final newNote = NotesModel(
        id: const Uuid().v4(),
        title: result['title']!,
        content: result['content']!,
        createdAt: DateTime.now(),
      );

      setState(() {
        notes.insert(0, newNote);
        _filterNotes('');
      });

      // Then fetch from server in background
      _fetchNotes().then((_) {
        // Optional: Show refresh complete message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.cloud_sync_outlined, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Notes synchronized'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      });

      // Show immediate success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Note added successfully'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleNoteDeleted(NotesModel deletedNote) {
    setState(() {
      notes.removeWhere((note) => note.id == deletedNote.id);
      _filterNotes('');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Note deleted'),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              notes.add(deletedNote);
              _filterNotes('');
            });
          },
        ),
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshNotes,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotes,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Welcome back, ${widget.username} 👋',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: _filterNotes,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search your notes...',
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
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Loading your notes...',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage!,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _refreshNotes,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : filteredNotes.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.note_add,
                                    size: 48,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No notes found\nTap + to create your first note',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: CustomScrollView(
                                slivers: [
                                  SliverMasonryGrid.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childCount: filteredNotes.length,
                                    itemBuilder: (context, index) {
                                      return FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: NoteCard(
                                          note: filteredNotes[index],
                                          onNoteUpdated: _handleNoteUpdated,
                                          onNoteDeleted: _handleNoteDeleted,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
            ),
          ],
        ),
      ),
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

  Future<void> _refreshNotes() async {
    await _fetchNotes();
  }

  void _handleNoteUpdated(NotesModel updatedNote) {
    setState(() {
      final index = notes.indexWhere((note) => note.id == updatedNote.id);
      if (index != -1) {
        notes[index] = updatedNote;
        _filterNotes('');
      }
    });
  }
}
