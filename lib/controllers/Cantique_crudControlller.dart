import 'package:cantique/models/cantique.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/providers.dart';

class CantiqueController {
  final Ref ref;
  CantiqueController(this.ref);

  Future<void> saveToCantique(
      String title, String urlSong, List content) async {
    print("sds");
    Cantique cantique = Cantique(
        id: -1,
        isFavourite: false,
        title: title,
        contenu: content,
        songUrl: urlSong,
        time: DateTime.now().toString());
    print(cantique.toMap());
    await ref.read(CantiqueDatasProvider).add(cantique.toMap());
  }

  Future<List<Cantique>> fetchAllTest() async {
    List<Cantique> models = [];
    await ref.read(CantiqueDatasProvider).get().then((value) {
      for (var element in value.docs) {
        models.add(Cantique.fromMap(element.data()));
      }
    });

    return models;
  }

  Future<List<Cantique>> getFavoriteCantique() async {
    List<Cantique> favoris = [];

    for(Cantique cantique in listeDemoCatique) {
      if (cantique.isFavourite) {
        favoris.add(cantique);
      }
    }

    return favoris;
  }
}
