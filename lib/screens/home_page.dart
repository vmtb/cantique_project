import 'package:cantique/components/app_button.dart';
import 'package:cantique/controllers/settings_controller.dart';
import 'package:cantique/screens/simple_user/liste_abc_cantique.dart';
import 'package:cantique/screens/simple_user/liste_cantique.dart';
import 'package:cantique/screens/simple_user/liste_favorite.dart';
import 'package:cantique/screens/simple_user/play_music.dart';
import 'package:cantique/screens/simple_user/recherche.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/app_text.dart';
import '../controllers/Cantique_crudControlller.dart';
import 'cantique/loginscreen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    isLoading = false;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLoginAndStat();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringData.accueil),
        leading: const Icon(Icons.home),
        actions: [
          ref.watch(darkFutureProvider).when(
              data: (data) {
                return IconButton(
                  onPressed: (() async {
                    ref.read(settingsController).saveDark(!data);
                  }),
                  icon: Icon(data ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                );
              },
              error: errorLoading,
              loading: loadingError),
          // IconButton(
          //   onPressed: (() {
          //     navigateToNextPage(context, const LoginScreen());
          //   }),
          //   icon: const Icon(Icons.admin_panel_settings_outlined),
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: getSize(context).width * 0.07),
                height: 60,
                //color: Colors.green[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: getSize(context).width * 0.6,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: StringData.entrerNumero,
                          hintStyle: TextStyle(
                            color: getPrimaryColor(context),
                          ),
                          focusColor: getPrimaryColor(context),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    AppButton(
                      height: 35,
                      width: 75,
                      child: isLoading
                          ? CupertinoActivityIndicator(
                              color: getWhite(context),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: AppText(
                                      StringData.go,
                                      color: getWhite(context),
                                      isNormal: false,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 1.0, top: 1),
                                    child: Icon(
                                      CupertinoIcons.forward,
                                      color: getWhite(context),
                                    ),
                                  ),
                                ]),
                      onTap: () async {
                        print("go pressed");
                        if (controller.text != "" && int.tryParse(controller.text) != null) {
                          print("go pressed OKKK");

                          setState(() {
                            isLoading = true;
                          });

                          StringData.id = int.parse(controller.text);

                          var res = ref
                              .read(listCantiqueRepo)
                              .where((element) => element.numero == int.parse(controller.text))
                              .toList();
                          setState(() {
                            isLoading = false;
                          });
                          if (res.isNotEmpty) {
                            navigateToNextPage(context, PlayMusics(cantique: res.first));
                          } else {
                            showFlushBar(context, "Recherche", "Veuillez saisir un numero valide  !!!!");
                          }
                        } else {
                          log("go pressed Noooo");
                          showFlushBar(context, "Recherche", "Veuillez saisir un numero valide");
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        navigateToNextPage(context, const ListeLikedCantique());
                      },
                      child: Container(
                        decoration: BoxDecoration(color: getBackCont(context), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 60,
                              color: getWhite(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText(
                              StringData.favorite,
                              color: getWhite(context),
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() {
                        navigateToNextPage(context, const ListeAbcCantique());
                      }),
                      child: Container(
                        decoration: BoxDecoration(color: getBackCont(context), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sort_by_alpha,
                              size: 60,
                              color: getWhite(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText(
                              "Sommaire",
                              color: getWhite(context),
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() {
                        navigateToNextPage(context, const RechercheCantique());
                      }),
                      child: Container(
                        decoration: BoxDecoration(color: getBackCont(context), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 60,
                              color: getWhite(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText(
                              StringData.search,
                              color: getWhite(context),
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() => navigateToNextPage(context, const ListeCantique())),
                      child: Container(
                        decoration: BoxDecoration(color: getBackCont(context), borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.list,
                              size: 60,
                              color: getWhite(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AppText(
                              StringData.cantique,
                              color: getWhite(context),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: getBackCont(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              "\u00a9",
              color: getWhite(context),
              align: TextAlign.center,
              size: 20,
            ),
            AppText(
              StringData.copyRight,
              color: getWhite(context),
              align: TextAlign.center,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkLoginAndStat() async {
    await ref.read(statController).getMyStat();

    var allCantique = await ref.read(CantiqueCrudController).geCantiques();
    ref.read(listCantiqueRepo.notifier).state = allCantique;
    ref.read(statController).updateStat(0, 1);
  }
}
