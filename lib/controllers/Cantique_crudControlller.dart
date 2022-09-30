import 'dart:io';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/providers.dart';

class CantiqueController {
  final Ref ref;
  CantiqueController(this.ref);

  Future<void> saveToCantique(String title, File? file, List content) async {
    //print("sds");

    await addFileToStorage(file!).then((value) async {
      String url = value;
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
    await ref.read(CantiqueDatasProvider).get().then((value) {
      for (var element in value.docs) {
        models.add(Cantique.fromMap(element.data()));
      }
    });

    return models;
  }

  Future<List<Cantique>> getFavoriteCantique() async {
    List<Cantique> favoris = [];
    ref.watch(fetchAllTest).whenData(
      (value) {
        for (Cantique cantique in value) {
          if (cantique.isFavourite) {
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

  Future<int> getCurrentId() async {
    int myId = 0;
    final snapshot = await ref.read(databaseRef).get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> json = snapshot.value as Map<dynamic, dynamic>;
      myId = json['id']! + 1;
      ref.read(databaseRef).set({"id": myId});
    } else {
      ref.read(databaseRef).set({"id": 0});
    }

    return myId;
  }

  Future<Cantique?> searchCantique() async {
    ref.watch(fetchAllTest).whenData((value) {
      for (Cantique cantique in value) {
        if (cantique.id == StringData.id) {
          return cantique;
        }
      }
    });
    return null;
  }
}
