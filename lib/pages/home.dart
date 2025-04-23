import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add.dart';

class Note{
  final String title;
  final String content;
  final String? imagePath;
  
  Note({required this.title, required this.content, this.imagePath});
  
  Map<String,dynamic> toJson()=>{
    'title':title,
    'content':content,
    'imagePath':imagePath,
  };
  
  factory Note.fromJson(Map<String,dynamic>json){
    return Note(
      title: json['title'],
      content: json['content'],
      imagePath: json['imagePath'],
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> notes = [];
  
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }
  void _addNote(Note newNote) {
    setState(() {
      notes.add(newNote);
    });
    _saveNotes();
  }
  
  Future<void> _loadNotes()async{
    final prefs=await SharedPreferences.getInstance();
    final notesString=prefs.getString('my_notes');
    if(notesString!=null&&notesString.isNotEmpty){
      try{
        final List<dynamic> decodedList=jsonDecode(notesString);
        setState(() {
          notes=decodedList.map((item)=>Note.fromJson(item)).toList();
        });
      }catch(e){
        print('Error decoding notes: $e');
      }
    }
  }
  Future<void> _saveNotes() async{
    final prefs=await SharedPreferences.getInstance();
    final List<Map<String,dynamic>> notesList=notes.map((note)=>note.toJson()).toList();
    await prefs.setString('my_notes', jsonEncode(notesList));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: notes.isEmpty?const Center(
        child: Text('Add some pics to display and describe about it.'),
      ):MasonryGridView.count(
        padding:const EdgeInsets.all(8.0),

          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        itemCount:notes.length,
        itemBuilder:(context,index) {
          final note = notes[index];
          return _NoteItems(note: note);
        },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed:()async{
          final newNote=await Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>const AddPage()),
          );
          if(newNote!=null&&newNote is Note) {
            _addNote(newNote);
          }
          },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _NoteItems extends StatelessWidget {
  final Note note;

  const _NoteItems({required this.note});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (note.imagePath != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.file(
                    File(note.imagePath!),
                    fit: BoxFit.cover,
                    height: 120, // Adjust as needed
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      note.content,
                      maxLines: note.imagePath != null ? 2 : null,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}