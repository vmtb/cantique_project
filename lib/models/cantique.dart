class Cantique {
  int id = -1;
  bool isFavourite = false;
  String title = "";
  String songUrl = "";
  String time = "";
  List contenu = [];

  Cantique(
      {
      required this.isFavourite,
      required this.id,
      required this.title,
      required this.songUrl,
      required this.contenu,
      required this.time});

  Map<String,dynamic> toMap() {
    return {
      'id':id,
      'favorite': isFavourite,
      'title': title,
      'songUrl': songUrl,
      'contenu': contenu,
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
      contenu: map['contenu'] as List,
    );
  }
}

List<Map<String, String>> listeContenu = [
  {
    "1": "Belle C'est un mot qu'on dirait inventé pour elle"
        "\nQuand elle danse et qu'elle met son corps à jour"
        "\nTel un oiseau qui étend ses ailes pour s'envoler"
        "\nAlors je sens l'enfer s'ouvrir sous mes pieds"
  },
  {
    "2": "J'ai posé mes yeux sous sa robe de gitane"
        "\nÀ quoi me sert encore de prier Notre-Dame"
        "\nQuel est celui qui lui jettera la première pierre?"
        "\nCelui-là ne mérite pas d'être sur terre"
  },
  {
    "Refrain": "Ô Lucifer! \nÔ laisse-moi rien qu'une fois"
        "\nGlisser mes doigts dans les cheveux d'Esmeralda"
  },
  {
    "1": "Belle C'est un mot qu'on dirait inventé pour elle"
        "\nQuand elle danse et qu'elle met son corps à jour"
        "\nTel un oiseau qui étend ses ailes pour s'envoler"
        "\nAlors je sens l'enfer s'ouvrir sous mes pieds"
  },
  {
    "2": "J'ai posé mes yeux sous sa robe de gitane"
        "\nÀ quoi me sert encore de prier Notre-Dame"
        "\nQuel est celui qui lui jettera la première pierre?"
        "\nCelui-là ne mérite pas d'être sur terre"
  },
];

List<Cantique> listeDemoCatique = [
  Cantique(
      id: 1,
      isFavourite: false,
      title: "Dieu est bon",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 2,
      isFavourite: true,
      title: "Amour infini",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 3,
      isFavourite: false,
      title: "La vie éternelest un don ",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 4,
      isFavourite: false,
      title: "Tiens toi bon sur le chemin",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 5,
      isFavourite: false,
      title: "La fin est proche",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 6,
      isFavourite: false,
      title: "Alléluyah",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 7,
      isFavourite: false,
      title: "Ma vie en tant que chrétien",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 8,
      isFavourite: false,
      title: "Zindo",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-17.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 9,
      isFavourite: false,
      title: "Daaga",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-18.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 10,
      isFavourite: false,
      title: "Donan tché aklunon",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 11,
      isFavourite: false,
      title: "Pardonne moi éternel",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 12,
      isFavourite: false,
      title: "Sans toi je ne suis rien seigneiur",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 13,
      isFavourite: false,
      title: "Kilisun ahosu",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-17.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 14,
      isFavourite: false,
      title: "Doonan tché - Doonoun mi",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-18.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 15,
      isFavourite: true,
      title: "Promet moi la vie éternel seigneur",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-19.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 16,
      isFavourite: true,
      title: "Sans toi je ne suis rien",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-20.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
  Cantique(
      id: 17,
      isFavourite: false,
      title: "Il est merveilleux",
      songUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-21.mp3",
      contenu: listeContenu,
      time: DateTime.now().toString()),
];
