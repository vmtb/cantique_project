class Cantique {
  String title = "";
  String songUrl = "";
  String time = "";
  List contenu = [];

  Cantique(
      {required this.title,
      required this.songUrl,
      required this.contenu,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'songUrl': songUrl,
      'contenu': contenu,
      'time': time,
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

List<Cantique> listeDemoCatique = [
  Cantique(
      title: "Dieu est bon",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Amour infini",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "La vie éternelest un don ",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Tiens toi bon sur le chemin",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "La fin est proche",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Alléluyah",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Ma vie en tant que chrétien",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Zindo",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Daaga",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Donan tché aklunon",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Pardonne moi éternel",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Sans toi je ne suis rien seigneiur",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Kilisun ahosu",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Doonan tché - Doonoun mi",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Promet moi la vie éternel seigneur",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Sans toi je ne suis rien",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
  Cantique(
      title: "Il est merveilleux",
      songUrl: "",
      contenu: [],
      time: DateTime.now().toString()),
];
