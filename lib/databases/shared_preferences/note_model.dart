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