import 'package:cantique/controllers/Cantique_crudControlller.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

final fetchCantiqueByCategorie =
    FutureProvider<List<Map<String, List<Cantique>>>>(
        (ref) => CantiqueController(ref).getAbcCantique());
