import 'package:cantique/components/app_text.dart';
import 'package:cantique/utils/app_const.dart';
import 'package:cantique/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListeCantique extends ConsumerStatefulWidget {
  const ListeCantique({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListeCantiqueState();
}

class _ListeCantiqueState extends ConsumerState<ListeCantique> {
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
          
        ],
      ),
    );
  }
}
