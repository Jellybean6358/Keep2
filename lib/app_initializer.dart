import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'databases/shared_preferences/note_model.dart';
import 'pages/home.dart';
import 'animations/loading.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _loadingComplete = false;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Simulate some initial loading (replace with your actual loading logic)
    await Future.delayed(const Duration(seconds: 2)); // Example delay

    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('my_notes');
    if (notesString != null && notesString.isNotEmpty) {
      try {
        final List<dynamic> decodedList = jsonDecode(notesString);
        _notes = decodedList.map((item) => Note.fromJson(item)).toList();
      } catch (e) {
        print('Error decoding notes: $e');
        // Handle error appropriately, maybe show an error message
      }
    }

    // After loading is complete, set the state to trigger navigation
    setState(() {
      _loadingComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingComplete) {
      return MyHomePage(title: 'My Notes', initialNotes: _notes);
    } else {
      return const LoadingScreen();
    }
    //return MyHomePage(title: 'My Notes', initialNotes: _notes);
  }
}