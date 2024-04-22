

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/statistique_model.dart';
import '../remote/dio/dio_client.dart';
import '../remote/dio/parse_result.dart';
import '../utils/app_const.dart';
import '../utils/app_func.dart';

final statRepo = Provider((ref) => StatistiqueRepo(ref));

class StatistiqueRepo {
  final Ref ref;
  String url = Urls.STAT_URL  ;

  StatistiqueRepo(this.ref);

  Future<FetchData> create(Statistique statistiqueModel) async {
    FetchData result = FetchData(data: null, error: "");
    await ref.read(dio).post(url,  data: FormData.fromMap(statistiqueModel.toMap())).then((value) {
      log(value);
      if (value.statusCode == 200) {
        //Statistique data = Statistique.fromMap(value.data);
        //result.data = data;
      } else {
        result.error = "Une erreur s'est produite... (${value.statusMessage})";
      }
    }).catchError((e, ee){
      log(ee);
      result.error = e.toString();
    });
    log(result.error);
    return result;
  }

  Future<FetchData> getWhere(Map<String, dynamic> where) async {
    FetchData result = FetchData(data: [], error: "");
    log("got to fetch $where");
    await ref.read(dio).post(url + Urls.WHERE_URL, data: where).then((value) {
      log(value);
      if (value.statusCode == 200) {
        List<Statistique> data = [];
        for (var element in value.data) {
          data.add(Statistique.fromMap(element));
        }
        result.data = data;
      } else {
        result.error = "Une erreur s'est produite... (${value.statusMessage})";
      }
    }).catchError((e, ee){
      log(ee);
      result.error = e.toString();
    });
    return result;
  }

  Future<FetchData> update(Statistique statistiqueModel) async {
    log(statistiqueModel.toMap());
    FetchData result = FetchData(data: null, error: "");
    await ref
        .read(dio)
        .put("$url/${statistiqueModel.id}", data: statistiqueModel.toMap())
        .then((value) {
      log(value);
      if (value.statusCode == 200) {
        Statistique data = Statistique.fromMap(value.data);
        result.data = data;
      } else {
        result.error = "Une erreur s'est produite... (${value.statusMessage})";
      }
    }).catchError((e, ee){
      log(ee);
      result.error = e.toString();
    });
    return result;
  }

}
