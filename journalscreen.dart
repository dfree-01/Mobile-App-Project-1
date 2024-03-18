// journal_entry.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daily_journal/database_helper.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String _selectedMood = ''; // Store the selected mood
  TextEditingController _journalEntryController =
      TextEditingController(); // Controller for the journal entry text field

  File? _imageFile;

  @override
  void dispose() {
    _journalEntryController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  void _saveEntry() async {
    String? _imagePath; // Declare a variable to hold the image path
    if (_imageFile != null) {
      _imagePath = _imageFile!.path; // Assign the image file path if not null
    }

    final entry = {
      'entry': _journalEntryController.text,
      'mood': _selectedMood,
      'date': DateTime.now().toString(),
      'imagePath': _imagePath,
    };

    try {
      await DatabaseHelper().insertEntry(entry);
      Navigator.pop(context, entry);
    } catch (e) {
      print('Image file: $_imageFile');
      print('Image path: $_imagePath');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Journal Entry'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _journalEntryController,
                decoration: InputDecoration(
                  labelText: 'Write your journal entry here',
                  border: OutlineInputBorder(),
                ),
                maxLines: null, // Allow multiple lines
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveEntry();
            },
            child: Text('Save Entry and Return to Home'),
          ),
          ElevatedButton(
            onPressed: () {
              _getImage(ImageSource.gallery);
            },
            child: Text('Upload Picture/Video'),
          ),
          _imageFile != null
              ? Image.file(_imageFile!) // Display selected image/video
              : Container(),
          Text('Select Mood: $_selectedMood'),
          Slider(
            value: _selectedMood == 'Good'
                ? 2
                : _selectedMood == 'Okay'
                    ? 1
                    : 0, // Reversed order: 0 = Good, 1 = Okay, 2 = Bad
            onChanged: (newValue) {
              setState(() {
                if (newValue == 0) {
                  _selectedMood = 'Bad';
                } else if (newValue == 1) {
                  _selectedMood = 'Okay';
                } else {
                  _selectedMood = 'Good';
                }
              });
            },
            min: 0,
            max: 2,
            divisions: 2,
            label: _selectedMood,
          ),
        ],
      ),
    );
  }
}
