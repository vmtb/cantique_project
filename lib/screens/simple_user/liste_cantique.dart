import 'package:cantique/components/app_text.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: getWhite(context),
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
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: StringData.entrerNumero,
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
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: ((context, index) {
                return Container(
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
                                (index + 1).toString(),
                                color: getWhite(context),
                              ),
                            ),
                          ),
                          const AppText("Titrre de l'évernement"),
                        ],
                      ),
                      //const SizedBox.expand(),
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
                );
              }),
              separatorBuilder: ((context, index) => Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getSize(context).width * 0.04),
                    height: 0,
                    color: Colors.grey,
                  )),
              itemCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
