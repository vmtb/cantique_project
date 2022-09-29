import 'dart:io';

import 'package:cantique/components/app_input.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/app_text.dart';
import '../../utils/app_const.dart';
import '../../utils/app_styles.dart';
import '../../utils/providers.dart';
import 'cantique_list.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:file_picker/file_picker.dart';

class AddCantique extends ConsumerStatefulWidget {
  const AddCantique({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddCantiqueState();
}

class _AddCantiqueState extends ConsumerState<AddCantique> {
  final titleController = TextEditingController();
  late List<String> content = [];
  File? filePicked;
  bool isLoading = false;
  String fileName = "Cliquez pour changer la musique";



  @override
  void initState() {
    content = contentToList("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          "Nouveau cantique",
          size: 18,
          color: getWhite(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    // FilePickerResult? result =
                    //     await FilePicker.platform.pickFiles();
                    // if (result == null) {
                    //   print("No file selected");
                    // } else {
                    //   print(result.files.single.name);
                    // }
                    pickFile();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: getSize(context).width,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: getBlack(context)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_note_rounded,
                            size: 50,
                            color: getBlack(context),
                          ),
                          AppText(fileName),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppInput(
                  controller: titleController,
                  label: "Titre du cantique",
                  validationBuilder: ValidationBuilder()),
              const SizedBox(
                height: 10,
              ),
              AppInput(
                  controller: titleController,
                  label: "Mélodie",
                  validationBuilder: ValidationBuilder()),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
                color: getBlack(context),
              ),
              const AppText("Sections (couplets)"),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                itemBuilder: (context, e) {
                  String part = content[e];
                  String index = "";
                  String cant = "";
                  log(e.toString() + "**" + part);
                  if (part.isEmpty) {
                    index = "";
                  } else {
                    index = content[e].split(separator2)[0];
                    cant = content[e].split(separator2)[1];
                  }
                  return SizedBox(
                    width: getSize(context).width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                              value: index == ""
                                  ? null
                                  : (index == "0" ? (e + 1).toString() : index),
                              decoration: InputDecoration(
                                labelText: "Numéro d'ordre",
                                /*floatingLabelBehavior: FloatingLabelBehavior.never,*/
                                suffixIcon: const Icon(Icons.numbers),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: "Refrain",
                                  child: AppText("Refrain"),
                                ),
                                DropdownMenuItem(
                                  value: (e + 1).toString(),
                                  child: AppText("Numéro ${(e + 1)}"),
                                )
                              ],
                              onChanged: (e_) {
                                index = e_ == "Refrain" ? "Refrain" : "0";
                                part = index + separator2 + cant;
                                content[e] = part;
                                setState(() {});
                              }),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Contenu du cantique",
                              /*floatingLabelBehavior: FloatingLabelBehavior.never,*/
                              suffixIcon: const Icon(Icons.music_note_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 50,
                            onChanged: (e_) {
                              cant = e_;
                              part = index + separator2 + cant;
                              content[e] = part;
                              setState(() {});
                            },
                            initialValue: cant,
                            validator: ValidationBuilder(
                                    requiredMessage: "Champ requis")
                                .build(),
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: Icon(
                                Icons.add,
                                color: getPrimaryColor(context),
                              ),
                              onPressed: () {
                                setState(() {
                                  content.add("");
                                });
                              },
                              label:
                                  AppText("", color: getPrimaryColor(context)),
                            ),
                            TextButton.icon(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                if (content.length != 1) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const AppText(
                                            "Confirmation",
                                            size: 22,
                                            weight: FontWeight.bold,
                                          ),
                                          content: const AppText(
                                            "Voulez-vous vraiment supprimer ce couplet?",
                                          ),
                                          actions: [
                                            TextButton.icon(
                                                icon: const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    log("To be deleted");
                                                    log(content[e]);
                                                    content.removeAt(e);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                label: const AppText("Oui",
                                                    color: Colors.red)),
                                            TextButton.icon(
                                              icon: Icon(
                                                Icons.close,
                                                color: getPrimaryColor(context),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              label: AppText("Non",
                                                  color:
                                                      getPrimaryColor(context)),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                              label: const AppText("", color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: content.length,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (filePicked == null) {
                      showFlushBar(context, "Choix de fichier audio",
                          "Veuillez sélectionner un fichier audio");
                    } else {
                      setState(() {
                        isLoading = true;
                      });

                      await ref
                          .read(CantiqueCrudController)
                          .saveToCantique(
                              titleController.text, filePicked, content)
                          .then((value) {
                        ref.refresh(fetchAllTest);
                        setState(() {
                          isLoading = false;
                        });
                        showFlushBar(context, "Message succes", "Ajout réussi");
                        navigateToNextPage(context, const CantiqueList());
                      });
                    }
                  },
                  child: isLoading
                      ? CupertinoActivityIndicator(
                          color: getWhite(context),
                        )
                      : const Text("Ajouter Cantique"))
            ],
          ),
        ),
      ),
    );
  }

  List<String> contentToList(String content) {
    return content.split(separator1);
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePicked = File(result.paths.first!);
        fileName = filePicked.toString().split('/').last.split('\'').first;
      });
    }
  }
}
