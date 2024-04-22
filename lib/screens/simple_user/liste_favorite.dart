import 'package:cantique/components/app_text.dart';
import 'package:cantique/screens/simple_user/play_music.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cantique_model.dart';

class ListeLikedCantique extends ConsumerStatefulWidget {
  const ListeLikedCantique({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListeLikedCantiqueState();
}

class _ListeLikedCantiqueState extends ConsumerState<ListeLikedCantique> {
  //CantiqueController cantiqueController;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cantiques Favoris"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              //color: getWhite(context),
            ),
            onPressed: (() => Navigator.pop(context)),
          )),
      body: RefreshIndicator(
        onRefresh: ()async {
          ref.read(CantiqueCrudController).geCantiques();
        },
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Builder(
              builder: (context) {
                if(isLoading){
                  return const CircularProgressIndicator();
                }

                if (datas.isEmpty) {
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
                              cantique: datas[index],
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
                                      (datas[index].numero).toString(),
                                      color: getWhite(context),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                AppText(
                                  datas[index].title,
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
                  itemCount: datas.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: getSize(context).width * 0.04),
                      height: 0,
                      color: Colors.grey,
                    );
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCantiqueFavList();
  }

  bool isLoading = false;

  List<CantiqueModel> datas = [];
  Future<void> getCantiqueFavList() async {
    setState((){
      isLoading = true;
    });
    datas = await ref.read(CantiqueCrudController).getFavoriteCantique();
    setState(() {
      isLoading = false;
    });
  }
}
