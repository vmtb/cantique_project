import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/setting_model.dart';
import '../remote/dio/dio_client.dart';
import '../remote/dio/parse_result.dart';
import '../utils/app_const.dart';
import '../utils/app_func.dart';

final settingRepo = Provider((ref) => SettingRepo(ref));

class SettingRepo {
  final Ref ref;
  String url = Urls.SETTING_URL  ;

  SettingRepo(this.ref);

  Future<FetchData> create(Setting settingModel) async {
    FetchData result = FetchData(data: null, error: "");
    await ref.read(dio).post(url,  data: settingModel.toMap()).then((value) {
      log(value);
      if (value.statusCode == 200) {
        Setting data = Setting.fromMap(value.data);
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
        List<Setting> data = [];
        for (var element in value.data) {
          data.add(Setting.fromMap(element));
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

  Future<FetchData> update(Setting settingModel) async {
    log(settingModel.toMap());
    FetchData result = FetchData(data: null, error: "");
    await ref
        .read(dio)
        .put("$url/${settingModel.id}", data: settingModel.toMap())
        .then((value) {
      log(value);
      if (value.statusCode == 200) {
        Setting data = Setting.fromMap(value.data);
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
