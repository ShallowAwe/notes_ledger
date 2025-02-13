import 'package:flutter/material.dart';
import 'package:notes_ledger/model/notes_model.dart';
import 'package:notes_ledger/screens/edit_note_screen.dart';

class NoteCard extends StatelessWidget {
  final NotesModel note;
  final Function(NotesModel) onNoteUpdated;
  final Function(NotesModel) onNoteDeleted;

  const NoteCard({
    super.key,
    required this.note,
    required this.onNoteUpdated,
    required this.onNoteDeleted,
  });

  @override
  Widget build(BuildContext context) {
    double cardHeight = _calculateCardHeight(note.content);

    return Container(
      width: 180, // Fixed width to make the grid look good
      height: cardHeight, // Dynamic height
      margin: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleNoteTap(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note.content,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(144),
                        ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateCardHeight(String content) {
    int length = content.length;

    if (length < 50) {
      return 120; // Square-like
    } else if (length < 150) {
      return 160; // Rectangle
    } else {
      return 220; // Taller rectangle
    }
  }

  Future<void> _handleNoteTap(BuildContext context) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(note: note),
      ),
    );

    if (result != null) {
      if (result == 'delete') {
        onNoteDeleted(note);
      } else if (result is NotesModel) {
        onNoteUpdated(result);
      }
    }
  }
}
