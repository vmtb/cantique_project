import 'package:cantique/components/app_text.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/models/cantique_model.dart';
import 'package:cantique/screens/simple_user/play_music.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/Cantique_crudControlller.dart';

class ListeCantique extends ConsumerStatefulWidget {
  const ListeCantique({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListeCantiqueState();
}

class _ListeCantiqueState extends ConsumerState<ListeCantique> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();

    liste = ref.read(listCantiqueRepo);
  }

  List<CantiqueModel> liste = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            //color: getWhite(context),
          ),
          onPressed: (() => Navigator.pop(context)),
        ),
        title: AppText(
          StringData.titleListe,
          color: getWhite(context),
          size: 18,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            margin:
                EdgeInsets.symmetric(horizontal: getSize(context).width * 0.04),
            //   height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: StringData.hintSearchByTitle,
                hintStyle: TextStyle(
                  color: getPrimaryColor(context),
                ),
                focusColor: getPrimaryColor(context),
                prefixIcon: Padding(
                  padding: const EdgeInsetsDirectional.all(8.0),
                  child: Icon(
                    Icons.search,
                    size: 27,
                    color: getBlack(context),
                  ),
                ),
                border: InputBorder.none,
              ),
              onChanged: searchCantique,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                loadCantiques();
              },
              child: ListView(
                children: [
                  isLoading? const Center(child: CircularProgressIndicator()):
                  ListOfResults(liste.isEmpty?ref.read(listCantiqueRepo):liste),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void searchCantique(String querry) {
    if(querry.trim().isEmpty){
      setState(() {
        liste = [];
      });
      return;
    }

    final suggestions = ref.read(listCantiqueRepo).where((cantique) {
      final input = querry.trim().toLowerCase();
      final cantiqueTitle = cantique.title.toLowerCase();
      log(cantiqueTitle);
      return cantiqueTitle.contains(input);
    }).toList();

    setState(() {
      liste = suggestions;
    });
  }

  Widget ListOfResults(List<CantiqueModel> data) {
    log(data);
    return ListView.separated(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            navigateToNextPage(
                context,
                PlayMusics(
                  cantique: data[index],
                ));
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: getSize(context).width * 0.04),
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              //color: Colors.green[100],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: getBackCont(context),
                        radius: 15,
                        child: AppText(
                          (data[index].numero).toString(),
                          color: getWhite(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    AppText(
                      data[index].title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.play_arrow,
                    color: getBackCont(context),
                    size: 25,
                  ),
                )
              ],
            ),
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: getSize(context).width * 0.04, vertical: 1),
          height: 0,
          color: Colors.grey,
        );
      },
    );
  }

  bool isLoading = false;
  Future<void> loadCantiques() async {
    setState(() {
      isLoading = true;
    });

    var allCantique = await ref.read(CantiqueCrudController).geCantiques();
    ref.read(listCantiqueRepo.notifier).state = allCantique;

    setState(() {
      isLoading = false;
    });
  }


}
