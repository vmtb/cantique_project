import 'dart:convert';
import 'dart:io';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/providers.dart';

class CantiqueController {
  final Ref ref;
  CantiqueController(this.ref);

  Future<void> saveToCantique(String title, File? file, List content) async {
    //print("sds");
    log("adding....");
    await addFileToStorage(file!).then((value) async {
      String url = value;
      log("save at $url....");
      await getCurrentId().then((value) async {
        Cantique cantique = Cantique(
            id: value,
            isFavourite: false,
            title: title,
            contenu: content,
            songUrl: url,
            time: DateTime.now().toString());

        await ref.read(CantiqueDatasProvider).add(cantique.toMap());
      });
    });
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

    await ref
        .read(CantiqueDatasProvider)
        .orderBy("id", descending: false)
        .get()
        .then((value) {
      for (var element in value.docs) {
        Cantique newC = Cantique.fromMap(element.data());
        if (favoriteListe.contains(newC.id)) {
          newC.isFavourite = true;
        }
        if (downloadedListe.containsKey(newC.id.toString())) {
          newC.songUrl = downloadedListe[newC.id.toString()];
        }

        models.add(newC);
      }
    });

    return models;
  }

  Future<List<Cantique>> getFavoriteCantique() async {
    List<Cantique> favoris = [];
    List<dynamic> favoriteListe = await getListeIdFavorite();
    ref.watch(fetchAllTest).whenData(
      (value) {
        for (Cantique cantique in value) {
          if (favoriteListe.contains(cantique.id)) {
            favoris.add(cantique);
          }
        }
      },
    );
    return favoris;
  }

  Future<List<Map<String, List<Cantique>>>> getAbcCantique() async {
    List<Map<String, List<Cantique>>> favoris = [];
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

    ref.watch(fetchAllTest).whenData(
      (value) {
        for (String str in liste) {
          favoris.add({str: []});

          for (Cantique cantique in value) {
            if (cantique.title.toUpperCase().startsWith(str)) {
              favoris[indix][str]!.add(cantique);
            }
          }
          indix++;
        }
      },
    );

    return favoris;
  }

  Future<void> delete(String id) async{

    print(id);

    await ref
        .read(CantiqueDatasProvider)
        .doc(id)
        .delete();


  }

  Future<int> getCurrentId() async {
    int myId = 1;
    final snapshot = await ref.read(databaseRef).get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> json = snapshot.value as Map<dynamic, dynamic>;
      myId = json['id']! + 1;
      ref.read(databaseRef).set({"id": myId});
    } else {
      ref.read(databaseRef).set({"id": 1});
    }

    return myId;
  }

  Future<Cantique?> searchCantique() async {
    log("Searching...");
    try {
      log("try Searching...");
      List<Cantique>? value = ref.read(fetchAllTest).value;
      List<Cantique> filtered =
          value!.where((element) => element.id == StringData.id).toList();
      if (filtered.isNotEmpty) {
        return filtered[0];
      }
    } catch (e) {
      log(e);
    }
    return null;
  }

  Future<Cantique?> getResultOfSearchById() async {
    // ignore: await_only_futures
    await ref.refresh(fetchCantiqueById);

    return ref.read(fetchCantiqueById).value;
  }

  Future<void> likeOrUnlikeCantique() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(StringData.favoritesKey)) {
      String data = jsonEncode([]);
      prefs.setString(StringData.favoritesKey, data);
    }

    if (StringData.myBool) {
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
      final data =
          jsonDecode(prefs.getString(StringData.localStorageCantique)!);
      return data as Map<dynamic, dynamic>;
    }
  }
}
