import 'package:cantique/components/app_text.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/screens/cantique/add_cantique.dart';
import 'package:cantique/screens/simple_user/play_music.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

<<<<<<< HEAD
=======
import '../../utils/app_styles.dart';
import '../../utils/providers.dart';

>>>>>>> d825c43 (Mise en place de la fonctionnalité d'affichage)
class CantiqueList extends ConsumerStatefulWidget {
  const CantiqueList({
    Key? key,
  }) : super(key: key);




  @override
  ConsumerState createState() => _CantiqueListState();
}

class _CantiqueListState extends ConsumerState<CantiqueList> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Cantique> liste = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            //color: getWhite(context),
          ),
          onPressed: (() => Navigator.pop(context)),
=======
        title: AppText(
          "Cantiques",
          size: 18,
          color: getWhite(context),
          
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            ref.watch(fetchAllTest).when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("No data"),
                    );
                  }

                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data[index].title),
                        subtitle: Text(data[index].time),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                },
                error: (err, stackErr) {
                  print(stackErr!);
                  return  Text(stackErr!.toString());
                },
                loading: () => const Center(child: CircularProgressIndicator())),
          ],
>>>>>>> d825c43 (Mise en place de la fonctionnalité d'affichage)
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
            child: ref.watch(fetchAllTest).when(
                data: ((data) {
                  setState(() {
                    liste = data;
                  });
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("No data found"),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          navigateToNextPage(
                              context,
                              PlayMusics(
                                cantique: liste[index],
                              ));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: getSize(context).width * 0.04),
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
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
                                        (liste[index].id).toString(),
                                        color: getWhite(context),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  AppText(
                                    liste[index].title,
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
                    }),
                    separatorBuilder: ((context, index) => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: getSize(context).width * 0.04),
                          height: 0,
                          color: Colors.grey,
                        )),
                    itemCount: liste.length,
                  );
                }),
                error: (err, stackErr) {
                  print(stackErr!);
                  return const Text("Something is wrong...");
                },
                loading: (() => const Center(
                      child: CircularProgressIndicator(),
                    ))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: getWhite(context),
        ),
        onPressed: () {
          navigateToNextPage(context, const AddCantique());
        },
      ),
    );
  }

  void searchCantique(String querry) {
    final suggestions = liste.where((cantique) {
      final input = querry.toLowerCase();
      final cantiqueTitle = cantique.title.toLowerCase();

      return cantiqueTitle.startsWith(input);
    }).toList();

    setState(() {
      liste = suggestions;
    });
  }
}
