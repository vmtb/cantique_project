import 'package:cantique/components/app_text.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/screens/simple_user/play_music.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListeAbcCantique extends ConsumerStatefulWidget {
  const ListeAbcCantique({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListeAbcCantiqueState();
}

class _ListeAbcCantiqueState extends ConsumerState<ListeAbcCantique> {
  @override
  Widget build(BuildContext context) {
    //ref.refresh(fetchCantiqueByCategorie);
    return Scaffold(
      appBar: AppBar(
        title: Text(StringData.tableAlpha),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            //color: getWhite(context),
          ),
          onPressed: (() => Navigator.pop(context)),
        ),
      ),
      body: ref.watch(fetchCantiqueByCategorie).when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(
                child: Text("Aucune donnée trouvée..."),
              );
            }
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getSize(context).width * 0.04,
                  vertical: getSize(context).height * 0.04),
              //height: 50,
              decoration:   BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  //border: Border.all(color: Colors.grey),
                  //color: Colors.green[100],
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 0.2),
                    BoxShadow(
                      color: Colors.grey,
                      blurStyle: BlurStyle.outer,
                      blurRadius: 1,
                    ),
                  ]),
              child: ListView.separated(
                itemBuilder: ((context, index) {
                  Map<String, List<Cantique>> newData = data[index];
                  List<Cantique> values = newData.values.first;

                  return Visibility(
                    visible: values.isNotEmpty,
                    child: ExpansionTile(
                      title: AppText(
                        newData.keys.first,
                        weight: FontWeight.bold,
                      ),
                      children: [
                        ...List.generate(
                          values.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                navigateToNextPage(
                                    context,
                                    PlayMusics(
                                      cantique: values[index],
                                    ));
                              },
                              child: Container(
                                // margin: EdgeInsets.symmetric(
                                // horizontal: getSize(context).width * 0.04),
                                height: 50,
                                decoration: const BoxDecoration(
                                    //border: Border.all(color: Colors.grey),
                                    boxShadow: [
                                    ]
                                    //color: Colors.green[100],
                                    ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                getBackCont(context),
                                            radius: 15,
                                            child: AppText(
                                              (values[index].id).toString(),
                                              color: getWhite(context),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        AppText(
                                          values[index].title,
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
                        ),
                      ],
                    ),
                  );
                }),
                shrinkWrap: true,
                itemCount: data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            );
          },
          error: (err, stackErr) {
            if (kDebugMode) {
              print(stackErr!);
            }
            return const Text("Something is wrong...");
          },
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
