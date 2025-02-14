import 'package:flutter/material.dart';
import 'package:notes_ledger/model/notes_model.dart';
import 'package:notes_ledger/screens/edit_note_screen.dart';
import 'package:intl/intl.dart';

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
    final formattedDate = DateFormat('MMM d, y').format(note.createdAt);

    return Hero(
      tag: 'note_${note.id}',
      child: Container(
        width: 170,
        height: cardHeight,
        margin: const EdgeInsets.all(8),
        child: Material(
          color: Colors.transparent,
          child: Card(
            elevation: 8,
            shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _handleNoteTap(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surfaceContainerLow,
                      Theme.of(context)
                          .colorScheme
                          .surfaceContainerLow
                          .withOpacity(0.9),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        note.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Date
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                              letterSpacing: 0.1,
                            ),
                      ),

                      const SizedBox(height: 8),

                      // Divider
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.1),
                      ),

                      const SizedBox(height: 8),

                      // Content
                      Expanded(
                        child: Text(
                          note.content,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.75),
                                    height: 1.5,
                                    letterSpacing: 0.1,
                                  ),
                          overflow: TextOverflow.fade,
                        ),
                      ),

                      // Actions Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                              ),
                              onPressed: () => _handleNoteTap(context),
                              splashRadius: 20,
                              tooltip: 'Edit note',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateCardHeight(String content) {
    int length = content.length;

    if (length < 50) {
      return 180; // Minimum height for consistency
    } else if (length < 150) {
      return 220;
    } else {
      return 260;
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
