import 'package:cantique/utils/app_func.dart';

class Cantique {
  int id = -1;
  bool isFavourite = false;
  String title = "";
  String songUrl = "";
  String time = "";
  String key = "";
  String melodie = "";
  List<String> contenu = [];

  Cantique(
      {
      required this.isFavourite,
      required this.id,
      required this.title,
      required this.songUrl,
      required this.key,
      required this.melodie,
      required this.contenu,
      required this.time});

  Map<String,dynamic> toMap() {
    return {
      'id':id,
      'favorite': isFavourite,
      'title': title,
      'songUrl': songUrl,
      'contenu': contenu,
      'melodie': melodie,
      'time': time,
    };
  }



  factory Cantique.fromMap(Map<String, dynamic> map) {
    return Cantique(
      id: map['id'] as int,
      isFavourite: map['favorite'] as bool,
      title: map['title'] as String,
      time: map['time'] as String,
      songUrl: map['songUrl'] as String,
      melodie: map['melodie']??"",
      key: "",
      contenu: convertMapListToListString( map['contenu']),
    );
  }

  static List<String> convertMapListToListString(List<dynamic> zinzin){
    log(zinzin);
    List<String> cants = [];
    zinzin.forEach((element) {
      cants.add(element);
    });
    return cants;
  }

  factory Cantique.initial()=>Cantique(isFavourite: false, melodie:"", id:-1, key: "", title: "", songUrl: "", contenu: [""], time: "");

  Cantique copyWith({
    int? id,
    bool? isFavourite,
    String? title,
    String? songUrl,
    String? time,
    String? key,
    String? melodie,
    List<String>? contenu,
  }) {
    return Cantique(
      id: id ?? this.id,
      key: key ?? this.key,
      isFavourite: isFavourite ?? this.isFavourite,
      melodie: melodie ?? this.melodie,
      title: title ?? this.title,
      songUrl: songUrl ?? this.songUrl,
      time: time ?? this.time,
      contenu: contenu ?? this.contenu,
    );
  }
}
