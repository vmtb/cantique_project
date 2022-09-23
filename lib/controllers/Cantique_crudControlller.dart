import 'package:cantique/models/cantique.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/providers.dart';

class CantiqueController{
  final Ref ref;
  CantiqueController(this.ref);

  Future<void> saveToCantique(String title,String urlSong,List content) async{
    print("sds");
    Cantique cantique = Cantique(title: title,contenu: content,songUrl: urlSong, time: DateTime.now().toString());
    print(cantique.toMap());
    await ref.read(CantiqueDatasProvider).add(cantique.toMap());
  }
}