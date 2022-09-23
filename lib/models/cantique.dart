class Cantique{

  String title="";
  String songUrl="";
  String time="";
  List contenu=[];


  Cantique({required this.title,required this.songUrl,required this.contenu,required this.time});

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'songUrl': this.songUrl,
      'contenu':this.contenu,
      'time': this.time,
    };
  }

  factory Cantique.fromMap(Map<String, dynamic> map) {
    return Cantique(
      title: map['title'] as String,
      time: map['time'] as String,
      songUrl: map['songUrl'] as String,
      contenu: map['contenu'] as List,
    );
  }


}