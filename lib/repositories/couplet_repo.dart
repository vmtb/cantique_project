import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/couplet_model.dart';
import '../remote/dio/dio_client.dart';
import '../remote/dio/parse_result.dart';
import '../utils/app_const.dart';
import '../utils/app_func.dart';

final coupletRepo = Provider((ref) => CoupletRepo(ref));

class CoupletRepo {
  final Ref ref;
  String url = Urls.COUPLET_URL  ;

  CoupletRepo(this.ref);

  Future<FetchData> create(Couplet coupletModel) async {
    FetchData result = FetchData(data: null, error: "");
    await ref.read(dio).post(url,  data: coupletModel.toMap()).then((value) {
      log(value);
      if (value.statusCode == 200) {
        Couplet data = Couplet.fromMap(value.data);
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
    await ref.read(dio).post(url + Urls.WHERE_URL, data: where).then((value) {
      log(value);
      if (value.statusCode == 200) {
        List<Couplet> data = [];
        for (var element in value.data) {
          data.add(Couplet.fromMap(element));
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

  Future<FetchData> update(Couplet coupletModel) async {
    log(coupletModel.toMap());
    FetchData result = FetchData(data: null, error: "");
    await ref
        .read(dio)
        .put("$url/${coupletModel.id}", data: coupletModel.toMap())
        .then((value) {
      log(value);
      if (value.statusCode == 200) {
        Couplet data = Couplet.fromMap(value.data);
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
