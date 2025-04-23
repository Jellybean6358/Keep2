//import 'package:apps/animations/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'databases/shared_preferences/note_model.dart';
import 'pages/home.dart';
import 'animations/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppInitializer(),
    );
  }
}

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
  }
}