import 'package:cantique/components/app_text.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/screens/simple_user/play_music.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RechercheCantique extends ConsumerStatefulWidget {
  const RechercheCantique({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RechercheCantiqueState();
}

class _RechercheCantiqueState extends ConsumerState<RechercheCantique> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Cantique> liste = listeDemoCatique;

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
          StringData.search,
          color: getWhite(context),
          size: 18,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
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
            height: 20,
          ),
          ref.watch(fetchAllTest).when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(
                    child: Text("No data"),
                  );
                }
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
                                      (data[index].id).toString(),
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
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: getSize(context).width * 0.04),
                      height: 0,
                      color: Colors.grey,
                    );
                  },
                );
              },
              error: (err, stackErr) {
                print(stackErr!);
                return const Text("Something is wrong...");
              },
              loading: () => const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  void searchCantique(String querry) {
    final suggestions = liste.where((cantique) {
      final input = querry.toLowerCase();
      final cantiqueTitle = cantique.title.toLowerCase();

      return cantiqueTitle.contains(input);
    }).toList();

    setState(() {
      liste = suggestions;
    });
  }
}
