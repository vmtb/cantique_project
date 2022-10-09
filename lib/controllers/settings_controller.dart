import 'package:cantique/utils/app_pref.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkProvider = StateProvider((ref)=>false);
final darkFutureProvider = FutureProvider((ref)=>SettingsController(ref).getIsDarkOrNot());

class SettingsController {
  final Ref ref;

  SettingsController(this.ref);

  Future<bool> getIsDarkOrNot() async{
    String? content = await getPreference("dark");
    if(content==null || content.isEmpty){
      //It's light
      ref.read(darkProvider.state).state = false;
      return false;
    }else{
      ref.read(darkProvider.state).state = true;
      return true;
    }
  }

  Future<bool> saveDark(bool isDark) async{
    savePreference("dark", isDark?"yes":"");
    ref.refresh(darkFutureProvider);
    return true;
  }

}