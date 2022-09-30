import 'package:cantique/components/app_text.dart';
import 'package:cantique/screens/cantique/cantique_list.dart';
import 'package:cantique/screens/simple_user/liste_abc_cantique.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          "Administration",
          size: 18,
          color: getWhite(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                    navigateToNextPage(context, const CantiqueList());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: getBackCont(context),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 60,
                          color: getWhite(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppText(
                          "Cantiques",
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
                    decoration: BoxDecoration(
                        color: getBackCont(context),
                        borderRadius: BorderRadius.circular(20)),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
