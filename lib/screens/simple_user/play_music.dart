import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cantique/components/app_text.dart';
import 'package:cantique/controllers/Cantique_crudControlller.dart';
import 'package:cantique/controllers/settings_controller.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/models/cantique_model.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class PlayMusics extends ConsumerStatefulWidget {
  PlayMusics({Key? key, required this.cantique}) : super(key: key);
  CantiqueModel cantique;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayMusicsState();
}

class _PlayMusicsState extends ConsumerState<PlayMusics> {
  //late Future<ListResult> futuresFiles;

  TextEditingController controller = TextEditingController();
  final audiPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isDownloading = false;

  final TransformationController _controller1 = TransformationController();

  @override
  void dispose() {
    controller.dispose();
    _controller1.dispose();
    audiPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setDernierQuantique();
  }

  double scale = 1;

  Future setAudio() async {
    String url = widget.cantique.song_url;
    await audiPlayer.setUrl(url, isLocal: !widget.cantique.song_url.contains("http"));

    audiPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.PLAYING;
      });
    });

    audiPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audiPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLocal = !widget.cantique.song_url.contains("http");
    widget.cantique.couplets!.sort((e,b)=>e.ordre.compareTo(b.ordre));
    setAudio();
    return Scaffold(
      appBar: AppBar(
        title: Text(StringData.lyrics),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            //color: getWhite(context),
          ),
          onPressed: (() => Navigator.pop(context)),
        ),
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
          IconButton(
            onPressed: (() {}),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InteractiveViewer(
          //clipBehavior: Clip.none,
          transformationController: _controller1,
          //panEnabled: false,
          scaleEnabled: false,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: getSize(context).width * 0.07),

              //color: Colors.green[100],
              /*    child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: getSize(context).width * 0.6,
                    child: TextFormField(
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
                    child: Row(
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
                    onTap: () => log("go button taped"),
                  ),
                ],
              ),*/
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppText(
                widget.cantique.numero.toString() + "- " + widget.cantique.title,
                size: 25,
                color: getPrimaryColor(context),
                isNormal: false,
                maxLines: 2,
                align: TextAlign.center,
                weight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            AppText(
              "Mélodie: ${widget.cantique.melodie}",
              size: 20,
              align: TextAlign.center,
              color: getPrimaryColor(context),
              isNormal: false,
            ),
            const SizedBox(
              height: 20,
            ),
            ...List.generate(widget.cantique.couplets!.length, (index) {
              var couplet = widget.cantique.couplets![index];

              String key = couplet.refrain==1?"Refrain":couplet.ordre.toString();
              String content = couplet.contenu;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    key,
                    align: TextAlign.center,
                    weight: FontWeight.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppText(
                      content,
                      align: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }).toList(),
            const SizedBox(
              height: 20,
            ),
            if (widget.cantique.song_url.isNotEmpty)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Slider(
                            min: 0,
                            max: 100,
                            value: duration.inSeconds == 0
                                ? 0
                                : position.inSeconds.toDouble() * 100 / duration.inSeconds.toDouble(),
                            onChanged: ((value) async {
                              final position = Duration(seconds: value * duration.inSeconds.toDouble() ~/ 100);
                              await audiPlayer.seek(position);
                              await audiPlayer.resume();
                            })),
                        Text(formatTime(duration - position)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (() async {
                          if (!isPlaying) {
                            await audiPlayer.resume();
                          }
                        }),
                        child: Container(
                          height: 30,
                          width: 70,
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            top: 6,
                          ),
                          decoration: BoxDecoration(
                            color: !isPlaying ? Colors.green : Colors.grey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          //child: IconButton(
                          child: Icon(
                            Icons.play_arrow,
                            color: getWhite(context),
                            size: 20,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (() async {
                          if (isPlaying) {
                            await audiPlayer.pause();
                          }
                        }),
                        child: Container(
                          height: 30,
                          width: 70,
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            top: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isPlaying ? getBackCont(context) : Colors.grey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          //child: IconButton(
                          child: Icon(
                            Icons.pause,
                            color: getWhite(context),
                            size: 20,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (() async {
                          if (isPlaying || position.inSeconds != 0) {
                            await audiPlayer.seek(const Duration(seconds: 0));
                            await audiPlayer.pause();
                          }
                        }),
                        child: Container(
                          height: 30,
                          width: 70,
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            top: 6,
                          ),
                          decoration: BoxDecoration(
                            color: (isPlaying || position.inSeconds != 0) ? Colors.red : Colors.grey,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(
                            Icons.square,
                            color: getWhite(context),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isLocal
                      ? Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: AppText("Téléchargé "),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () async {
                            setState(() {
                              isDownloading = true;
                            });
                            await download().then((value) async {
                              if (value != null) {
                                StringData.cantiqueDowloaded = {widget.cantique.id.toString(): value.path};
                                await ref.read(CantiqueCrudController).downloadCantique();
                                ref.refresh(fetchAllTest);

                                setState(() {
                                  isLocal = true;
                                  isDownloading = false;
                                });
                              }
                            });
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: AppText("Télécharger ? "),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isDownloading ? const CircularProgressIndicator() : const Icon(Icons.download),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: getBackCont(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: (() async {
                  int currentId = ref.read(listCantiqueRepo).indexOf(widget.cantique);

                  if (currentId>0) {
                    setState(() {
                      widget.cantique = ref.read(listCantiqueRepo)[currentId-1];
                      checkMyFavorite();
                    });
                  } else {
                    showFlushBar(context, "Recherche", "Vous êtes sur le premier cantique");
                  }
                }),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: getWhite(context),
                )),
            IconButton(
                onPressed: (() {
                  setState(() {
                    scale -= 0.1;
                    _controller1.value = Matrix4.identity()..scale(scale);
                  });
                }),
                icon: Icon(
                  Icons.zoom_out,
                  color: getWhite(context),
                )),
            IconButton(
                onPressed: (() async {
                  StringData.addToFavorite = !isFavorite;
                  StringData.favoriteId = widget.cantique.id;
                  ref.read(CantiqueCrudController).likeOrUnlikeCantique();
                  checkMyFavorite();
                }),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: getWhite(context),
                )),
            IconButton(
              onPressed: (() {
                setState(() {
                  scale += 0.1;
                  _controller1.value = Matrix4.identity()..scale(scale);
                });
              }),
              icon: const Icon(Icons.zoom_in),
              color: getWhite(context),
            ),
            IconButton(
              onPressed: (() async {
                StringData.id = widget.cantique.id + 1;
                int currentId = ref.read(listCantiqueRepo).indexOf(widget.cantique);

                if (currentId<ref.read(listCantiqueRepo).length-1) {
                  setState(() {
                    widget.cantique = ref.read(listCantiqueRepo)[currentId+1];
                    checkMyFavorite();
                  });
                } else {
                  showFlushBar(context, "Recherche", "Vous êtes sur le dernier cantique");
                }
              }),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: getWhite(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(Duration position) {
    int seconds = position.inSeconds.toInt();

    String minuteString = '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString';
  }

  Map<String, String> treatContent(contenu) {
    List<String> c = contenu.toString().split(separator2);
    if (int.tryParse(c[0]) is int) {
      return {(int.tryParse(c[0])).toString(): c[1]};
    }

    return {"Refrain": c[1]};
  }

  Future<File?> download() async {
    log("start-------------->");
    final appStorage = await getApplicationDocumentsDirectory();

    log('${appStorage.path}/localMusiques${widget.cantique.id}.${widget.cantique.song_url.split("/").last}');

    final file =
        File('${appStorage.path}/localMusiques${widget.cantique.id}.${widget.cantique.song_url.split("/").last}');
    try {
      final response = await Dio().get(widget.cantique.song_url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: const Duration(seconds: 3),
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  bool isFavorite = false;
  checkMyFavorite() async {
    List<CantiqueModel> list = await ref.read(CantiqueCrudController).getFavoriteCantique();
    isFavorite = list.where((element) => element.id==widget.cantique.id).isNotEmpty;
    setState(() {

    });
  }

  void setDernierQuantique() {
    ref.read(statController).updateStat(widget.cantique.id, 0);
  }
}
