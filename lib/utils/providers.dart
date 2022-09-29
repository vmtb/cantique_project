import 'package:cantique/controllers/Cantique_crudControlller.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/screens/cantique/cantique_list.dart';
import 'package:cantique/controllers/Cantique_crudControlller.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Provider<FirebaseAuth> mAuthRef = Provider((ref) => FirebaseAuth.instance);
Provider<CollectionReference> userRef =
    Provider((ref) => FirebaseFirestore.instance.collection("Users"));
Provider<Reference> thumbStorageRef =
    Provider((ref) => FirebaseStorage.instance.ref().child("Audios"));

final CantiqueDatasProvider =
    Provider((ref) => FirebaseFirestore.instance.collection("Cantiques"));
final CantiqueCrudController = Provider((ref) => CantiqueController(ref));


final fetchAllTest = FutureProvider<List<Cantique>>((ref)=>CantiqueController(ref).fetchAllTest());

final fetchFavoriteCantique = FutureProvider<List<Cantique>>((ref)=>CantiqueController(ref).getFavoriteCantique());

//DatabaseReference ref = FirebaseDatabase.instance.ref("users/$phoneNumber/phones/${StringData.myIme}");
Provider<DatabaseReference> databaseRef =
    Provider((ref) => FirebaseDatabase.instance.ref().child("CURRENT_ID"));

