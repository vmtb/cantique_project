import 'dart:convert';
import 'dart:io';

import 'package:cantique/models/cantique.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/helper_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cantique_model.dart';
import '../repositories/cantique_repo.dart';
import '../utils/providers.dart';


final StateProvider<List<CantiqueModel>> listCantiqueRepo = StateProvider<List<CantiqueModel>>((ref) => []);

class CantiqueController {
  final Ref ref;

  CantiqueController(this.ref);

  Future<void> saveToCantique(Cantique c, int id, String title, File? file, List<String> content) async {
    //print("sds");
    log("adding....");
    if (file == null) {
      Cantique cantique =
          c.copyWith(id: id, isFavourite: false, title: title, contenu: content, time: DateTime.now().toString());
      await saveOrUpdate(cantique);
    } else {
      await addFileToStorage(file).then((value) async {
        String url = value;
        log("save at $url....");
        Cantique cantique = c.copyWith(
            id: id, isFavourite: false, title: title, contenu: content, songUrl: url, time: DateTime.now().toString());
        await saveOrUpdate(cantique);
      });
    }
  }

  Future saveOrUpdate(Cantique c) async {
    if (c.key.isEmpty) {
      await ref.read(CantiqueDatasProvider).add(c.toMap());
    } else {
      await ref.read(CantiqueDatasProvider).doc(c.key).set(c.toMap());
    }
  }

  Future<String> addFileToStorage(File file) async {
    UploadTask task = ref.read(thumbStorageRef).putFile(file);
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }

  Future<List<Cantique>> fetchAllTest1() async {
    List<Cantique> models = [];
    print("--------> liste favoris ");
    List<dynamic> favoriteListe = await getListeIdFavorite();
    print("--------> liste download ");
    Map<dynamic, dynamic> downloadedListe = await listeDownloaded();
    print(downloadedListe);

    await ref.read(CantiqueDatasProvider).orderBy("id", descending: false).get().then((value) {
      for (var element in value.docs) {
        log(element.data());
        Cantique newC = Cantique.fromMap(element.data());
        if (favoriteListe.contains(newC.id)) {
          newC.isFavourite = true;
        }
        if (downloadedListe.containsKey(newC.id.toString())) {
          newC.songUrl = downloadedListe[newC.id.toString()];
        }
        newC = newC.copyWith(key: element.id);

        models.add(newC);
      }
    });

    return models;
  }

  Future<List<CantiqueModel>> getFavoriteCantique() async {
    List<CantiqueModel> favoris = [];

    if(ref.read(listCantiqueRepo).isEmpty){
      await geCantiques();
    }

    List<dynamic> favoriteListe = await getListeIdFavorite();
    for (CantiqueModel cantique in ref.read(listCantiqueRepo)) {
      if (favoriteListe.contains(cantique.id)) {
        favoris.add(cantique);
      }
    }

    return favoris;
  }

  Future<List<Map<String, List<CantiqueModel>>>> getAbcCantique() async {
    List<Map<String, List<CantiqueModel>>> favoris = [];
    int indix = 0;
    List<String> liste = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ];
    if(ref.read(listCantiqueRepo).isEmpty){
      await geCantiques();
    }
    for (String str in liste) {
      List<CantiqueModel> cc = [];
      for (CantiqueModel cantique in ref.read(listCantiqueRepo)) {
        if (cantique.title.toUpperCase().startsWith(str)) {
          cc.add(cantique);
        }
      }
      if (cc.isNotEmpty) {
        favoris.add({str: cc});
      }
      indix++;
    }

    return favoris;
  }

  Future<void> delete(int id) async {
    final a = await ref.read(CantiqueDatasProvider).where('id', isEqualTo: id).get().then((value) => value);

    await ref.read(CantiqueDatasProvider).doc(a.docs[0].id).delete();
  }


  Future<Cantique?> searchCantique() async {
    log("Searching...");
    try {
      log("try Searching...");
      List<Cantique>? value = ref.read(fetchAllTest).value;
      List<Cantique> filtered = value!.where((element) => element.id == StringData.id).toList();
      if (filtered.isNotEmpty) {
        return filtered[0];
      }
    } catch (e) {
      log(e);
    }
    return null;
  }


  Future<void> likeOrUnlikeCantique() async {


    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(StringData.favoritesKey)) {
      String data = jsonEncode([]);
      prefs.setString(StringData.favoritesKey, data);
    }

    //Enregistrer les IDS dans une liste
    if (StringData.addToFavorite) {
      final data = jsonDecode(prefs.getString(StringData.favoritesKey)!);
      List<dynamic> liste = data as List<dynamic>;
      liste.add(StringData.favoriteId);
      prefs.setString(StringData.favoritesKey, jsonEncode(liste));
    } else {
      final data = jsonDecode(prefs.getString(StringData.favoritesKey)!);
      List<dynamic> liste = data as List<dynamic>;
      liste.removeWhere(((element) {
        return element == StringData.favoriteId;
      }));
      prefs.setString(StringData.favoritesKey, jsonEncode(liste));
    }

    ref.refresh(fetchAllTest);
  }

  Future<List<dynamic>> getListeIdFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(StringData.favoritesKey)) {
      String data = jsonEncode([]);
      prefs.setString(StringData.favoritesKey, data);
      return [];
    } else {
      final data = jsonDecode(prefs.getString(StringData.favoritesKey)!);
      return data as List<dynamic>;
    }
  }

  Future<void> downloadCantique() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(StringData.localStorageCantique)) {
      Map<String, String> format = {"0": "000"};

      String data1 = jsonEncode(format);
      prefs.setString(StringData.localStorageCantique, data1);
    }

    final data = jsonDecode(prefs.getString(StringData.localStorageCantique)!);

    if (kDebugMode) {
      print("Après decode ");
      print(data);
    }

    Map<dynamic, dynamic> liste = data as Map<dynamic, dynamic>;

    liste.addEntries(StringData.cantiqueDowloaded.entries);
    if (kDebugMode) {
      print("Liste des chansons locals :");
      print(liste);
    }
    prefs.setString(StringData.localStorageCantique, jsonEncode(liste));
  }

  Future<Map<dynamic, dynamic>> listeDownloaded() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(StringData.localStorageCantique)) {
      String data = jsonEncode({});
      prefs.setString(StringData.localStorageCantique, data);
      return {};
    } else {
      final data = jsonDecode(prefs.getString(StringData.localStorageCantique)!);
      return data as Map<dynamic, dynamic>;
    }
  }

  Future<List<CantiqueModel>> geCantiques() async {
    var list =  (await ref.read(cantiqueRepo).getWhere({"active": 1})).data;
    log("list $list");
    ref.read(listCantiqueRepo.notifier).state = list;
    return list;
  }
}
