import 'package:cantique/components/app_button.dart';
import 'package:cantique/components/app_text.dart';
import 'package:cantique/models/cantique.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayMusics extends ConsumerStatefulWidget {
  PlayMusics({Key? key, required this.cantique}) : super(key: key);
  Cantique cantique;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayMusicsState();
}

class _PlayMusicsState extends ConsumerState<PlayMusics> {
  TextEditingController controller = TextEditingController();
  final audiPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  final TransformationController _controller1 = TransformationController();

  @override
  void dispose() {
    controller.dispose();
    audiPlayer.dispose();
    _controller1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setAudio();
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
    super.initState();
  }

  double scale = 1;

  Future setAudio() async {
    String url = widget.cantique.songUrl;
    await audiPlayer.setUrl(url);
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.cantique.contenu[index] as Map<String, String>;
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
            Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: ((value) async {
                  final position = Duration(seconds: value.toInt());
                  await audiPlayer.seek(position);
                  await audiPlayer.resume();
                })),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(formatTime(position)),
                  AppText(formatTime(duration - position)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: getBlack(context),
                radius: 30,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: getWhite(context),
                    ),
                    iconSize: 50,
                    onPressed: (() async {
                      if (isPlaying) {
                        await audiPlayer.pause();
                      } else {
                        await audiPlayer.resume();
                      }
                    }),
                  ),
                ),
              ),
            )
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
                onPressed: (() {}),
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
                onPressed: (() {}),
                icon: Icon(
                  Icons.favorite,
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
              onPressed: (() {}),
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
}
