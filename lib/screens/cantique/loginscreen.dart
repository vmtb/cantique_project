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


  @override
  void initState(){
    super.initState();
    pseudoController=TextEditingController();
    passController=TextEditingController();
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
          padding: EdgeInsets.symmetric(horizontal: 15),
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
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: getPrimaryColor(context),
                  ),
                  focusColor: getPrimaryColor(context),
                ),
              ),

              ElevatedButton(onPressed: (){
                if (pseudoController.text.trim()=="admin"){
                  if (pseudoController.text.trim()=="admin"){
                    navigateToNextPage(context, const AdminHomePage() );

                  }
                }

              }, child: Text("Se connecter en tant admin"))
            ],
          ) ,
        ),
      )
      ),
    );
  }
}


