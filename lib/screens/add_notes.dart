import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddNoteScreen extends StatefulWidget {
  final String username;
  final String token;

  const AddNoteScreen({super.key, required this.username, required this.token});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false; // Tracks loading state

  Future<void> _postNotes() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    // final url =
    //     Uri.parse('http://10.0.2.2:8080/user/${widget.username}/savenote');
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/user/${widget.username}/savenote'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer ${widget.token}", // Make sure the token is valid
        },
        body: jsonEncode({
          'title': _titleController.text.trim(),
          'content': _contentController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Note saved successfully! ✨'),
            elevation: 2,
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to save note: ${response.body}'),
            elevation: 2,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Error: $e'),
          elevation: 2,
          backgroundColor: Colors.orange,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            // Save Button with Loading State
            ElevatedButton(
              onPressed: _isLoading ? null : _postNotes, // Disable when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.grey : Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Save Note ✍️', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
