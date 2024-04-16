import 'package:cantique/components/app_text.dart';
import 'package:cantique/utils/app_pref.dart';
import 'package:flutter/material.dart';

import '../../utils/app_func.dart';
import '../../utils/app_styles.dart';
import '../admin_home_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController pseudoController;
  late  TextEditingController passController;
  bool rem= false;

  @override
  void initState(){
    super.initState();
    pseudoController=TextEditingController();
    passController=TextEditingController();
    remember();
  }

  @override
  void dispose(){
    pseudoController.dispose();
    passController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: pseudoController,

                decoration: InputDecoration(
                  hintText: "Pseudo",

                  hintStyle: TextStyle(
                    color: getPrimaryColor(context),
                  ),
                  focusColor: getPrimaryColor(context),
                ),
              ),
              TextFormField(

                  controller: passController,
                  obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: getPrimaryColor(context),
                  ),
                  focusColor: getPrimaryColor(context),
                ),
              ),
              CheckboxListTile(value: rem, onChanged: (e){
                setState(() {
                  rem = e!;
                });
              }, title: const AppText("Se souvenir de moi"),),

              ElevatedButton(onPressed: (){
                //navigateToNextPage(context, const AdminHomePage() );
                if (pseudoController.text.trim()=="admin"){
                  if (passController.text.trim()=="pirc-cantiquejjc"){
                    if(rem){
                      savePreference("login", "admin");
                      savePreference("pass", "pirc-cantiquejjc");
                    }else{
                      savePreference("login", "");
                      savePreference("pass", "");
                    }
                    navigateToNextPage(context, const AdminHomePage() );

                  }
                }

              }, child: const Text("Se connecter en tant admin"))
            ],
          ) ,
        ),
      )
      ),
    );
  }

  void remember()async {
    if(await getPreference("login")!=""){
      pseudoController.text = (await getPreference("login"))!;
      passController.text = (await getPreference("pass"))!;
      rem = true;
      setState(() {

      });
    }
  }
}


