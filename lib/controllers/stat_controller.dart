import 'package:cantique/models/statistique_model.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/stat_repo.dart';
StateProvider<Statistique> myStat  = StateProvider<Statistique>((ref) => Statistique.initial());
class StatController{
  final Ref ref;

  StatController(this.ref);

  getMyStat() async {
    if(ref.read(mAuthRef).currentUser==null){
      createStat();
      return;
    }
    String user_id = ref.read(mAuthRef).currentUser!.uid;
    List<Statistique> stats = [];
    try {
      stats = (await ref.read(statRepo).getWhere({"user_id": user_id})).data;
    } catch (e) {
      print(e);
    }
    if(stats.isEmpty){
      createStat();
    }else{
      ref.read(myStat.notifier).state = stats.first;
    }
  }

  createStat() async {
    if(ref.read(mAuthRef).currentUser==null){
      await ref.read(mAuthRef).signInAnonymously();
    }
    Statistique s = ref.read(myStat).copyWith(user_id: ref.read(mAuthRef).currentUser!.uid, open: 1, last_open: DateTime.now().toString());
    log(s.toMap());
    await ref.read(statRepo).create(s);
    getMyStat();
  }

  Future<void> updateStat(int cantiqueId, int open) async {
    Statistique s = ref.read(myStat);
    if(cantiqueId>0){
      s = s.copyWith(last_cantique_open_id: cantiqueId);
    }
    if(open>0){
      s = s.copyWith(open: s.open+1, last_open: DateTime.now().toString());
    }
    await ref.read(statRepo).update(s);
    getMyStat();
  }
}