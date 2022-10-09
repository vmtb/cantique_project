import 'dart:io';

import 'package:cantique/components/app_button.dart';
import 'package:cantique/components/app_text.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:cantique/utils/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayMusics extends ConsumerStatefulWidget {
  PlayMusics({Key? key, required this.cantique}) : super(key: key);
  Cantique cantique;
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

  final TransformationController _controller1 = TransformationController();

  @override
  void dispose() {
    controller.dispose();
    _controller1.dispose();
    audiPlayer.dispose();
    super.dispose();
  }

  String _localPath = "";
  bool _permissionReady = false;
  TargetPlatform? platform = TargetPlatform.android;

  @override
  void initState() {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    }
    //futuresFiles = ref.read(thumbStorageRefAll).listAll();
    super.initState();
  }

  double scale = 1;

  Future setAudio() async {
    String url = widget.cantique.songUrl;
    await audiPlayer.setUrl(url, isLocal: false);

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
          IconButton(
            onPressed: (() {}),
            icon: const Icon(Icons.light_mode_rounded),
          ),
          IconButton(
            onPressed: (() {}),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: InteractiveViewer(
          //clipBehavior: Clip.none,
          transformationController: _controller1,
          //panEnabled: false,
          scaleEnabled: false,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: getSize(context).width * 0.07),
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
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppText(
              widget.cantique.id.toString() + "- " + widget.cantique.title,
              size: 25,
              color: getPrimaryColor(context),
              isNormal: false,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 15,
            ),
            AppText(
              "Mélodie: Praise ye the father",
              size: 20,
              color: getPrimaryColor(context),
              isNormal: false,
            ),
            const SizedBox(
              height: 20,
            ),
            ...List.generate(widget.cantique.contenu.length, (index) {
              Map<String, String> data =
                  treatContent(widget.cantique.contenu[index]);

              String key = data.keys.first;
              String content = data.values.first;
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
                          : position.inSeconds.toDouble() *
                              100 /
                              duration.inSeconds.toDouble(),
                      onChanged: ((value) async {
                        final position = Duration(
                            seconds:
                                value * duration.inSeconds.toDouble() ~/ 100);
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
                      color: (isPlaying || position.inSeconds != 0)
                          ? Colors.red
                          : Colors.grey,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    //child: IconButton(
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
            Row(
              children: [
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: AppText("Télécharger ? "),
                  ),
                  onTap: () async {
                    _permissionReady = await _checkPermission();
                    if (_permissionReady) {
                      await _prepareSaveDir();
                      if (kDebugMode) {
                        print("Downloading");
                      }
                      try {
                        await Dio().download(widget.cantique.songUrl,
                            _localPath + "/" + "audio${widget.cantique.id}");
                        if (kDebugMode) {
                          print("Download Completed.");
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print("Download Failed.\n\n" + e.toString());
                        }
                      }
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.download),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                  StringData.id = widget.cantique.id - 1;
                  Cantique? value = await ref
                      .read(CantiqueCrudController)
                      .getResultOfSearchById();
                  if (value is Cantique) {
                    setState(() {
                      widget.cantique = value;
                    });
                  } else {
                    showFlushBar(context, "Recherche",
                        "Vous êtes sur la première cantique");
                  }
                  ref.read(fetchCantiqueById).whenData((value) {});
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
                  setState(() {
                    widget.cantique.isFavourite = !widget.cantique.isFavourite;
                  });

                  StringData.myBool = widget.cantique.isFavourite;
                  StringData.favoriteId = widget.cantique.id;
                  ref.refresh(favoriseOrUnfavorise);
                  //ref.read(favoriseOrUnfavorise).whenData((value) => null);
                }),
                icon: Icon(
                  widget.cantique.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
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
                Cantique? value = await ref
                    .read(CantiqueCrudController)
                    .getResultOfSearchById();
                if (value is Cantique) {
                  setState(() {
                    widget.cantique = value;
                  });
                } else {
                  showFlushBar(context, "Recherche",
                      "Vous êtes sur la dernière cantique");
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

    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
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

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    //print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    var directory = await getApplicationDocumentsDirectory();
    print("###################${directory.path + Platform.pathSeparator + 'Download'}");
    return directory.path + Platform.pathSeparator + 'Download';
  }
}
