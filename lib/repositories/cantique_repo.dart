import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cantique_model.dart';
import '../remote/dio/dio_client.dart';
import '../remote/dio/parse_result.dart';
import '../utils/app_const.dart';
import '../utils/app_func.dart';

final cantiqueRepo = Provider((ref) => CantiqueModelRepo(ref));

class CantiqueModelRepo {
  final Ref ref;
  String url = Urls.CANTIQUE_URL  ;

  CantiqueModelRepo(this.ref);

  Future<FetchData> create(CantiqueModel cantiqueModel) async {
    FetchData result = FetchData(data: null, error: "");
    await ref.read(dio).post(url,  data: cantiqueModel.toMap()).then((value) {
      log(value);
      if (value.statusCode == 200) {
        CantiqueModel data = CantiqueModel.fromMap(value.data);
        result.data = data;
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
    await ref.read(dio).post(url + Urls.WHERE_URL, data: FormData.fromMap(where)).then((value) {
      log(value);
      if (value.statusCode == 200) {
        List<CantiqueModel> data = [];
        for (var element in value.data) {
           data.add(CantiqueModel.fromMap(element));
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

  Future<FetchData> update(CantiqueModel cantiqueModel) async {
    log(cantiqueModel.toMap());
    FetchData result = FetchData(data: null, error: "");
    await ref
        .read(dio)
        .put("$url/${cantiqueModel.id}", data: cantiqueModel.toMap())
        .then((value) {
      log(value);
      if (value.statusCode == 200) {
        CantiqueModel data = CantiqueModel.fromMap(value.data);
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
