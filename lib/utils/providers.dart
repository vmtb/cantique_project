import 'package:cantique/controllers/settings_controller.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/controllers/Cantique_crudControlller.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/stat_controller.dart';

Provider<FirebaseAuth> mAuthRef = Provider((ref) => FirebaseAuth.instance);

Provider<CollectionReference> userRef = Provider((ref) => FirebaseFirestore.instance.collection("Users"));

Provider<Reference> thumbStorageRef =  Provider((ref) => FirebaseStorage.instance.ref().child("Audios").child(DateTime.now().microsecondsSinceEpoch.toString()+"__"+StringData.extension+"__"));

Provider<Reference> thumbStorageRefAll =  Provider((ref) => FirebaseStorage.instance.ref().child("Audios"));

final CantiqueDatasProvider = Provider((ref) => FirebaseFirestore.instance.collection("Cantiques"));

final CantiqueCrudController = Provider((ref) => CantiqueController(ref));
final statController = Provider<StatController>((ref) => StatController(ref));

final settingsController = Provider((ref) => SettingsController(ref));

final fetchAllTest = FutureProvider<List<Cantique>>((ref) => CantiqueController(ref).fetchAllTest1());


final favoriseOrUnfavorise = FutureProvider<void>((ref) => CantiqueController(ref).likeOrUnlikeCantique());
