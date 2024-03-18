import 'package:flutter/material.dart';
import 'package:daily_journal/journalscreen.dart';
import 'package:daily_journal/database_helper.dart'; // Import the DatabaseHelper class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _journalEntries =
      []; // Define a list to hold journal entries

  @override
  void initState() {
    super.initState();
    _fetchEntries(); // Call method to fetch entries when screen initializes
  }

  Future<void> _fetchEntries() async {
    _journalEntries =
        await DatabaseHelper().getEntries(); // Fetch entries from the database
    setState(() {}); // Update UI with fetched entries
  }

  Widget _buildEntriesList() {
    return ListView.builder(
      itemCount: _journalEntries.length,
      itemBuilder: (context, index) {
        final entry = _journalEntries[index];
        return ListTile(
          title: Text(entry['entry']),
          subtitle: Text(entry['date']),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Journal with Mood Tracker'),
      ),
      body: _journalEntries
              .isNotEmpty // Show entries list if not empty, otherwise display a message
          ? _buildEntriesList()
          : Center(child: Text('No Entries')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JournalScreen()),
          );
          if (result != null) {
            _fetchEntries();
          }
        },
        tooltip: 'Add Entry',
        child: Icon(Icons.add),
      ),
    );
  }
}
