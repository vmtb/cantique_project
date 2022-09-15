import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppImageNetwork extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final bool isProgress;

  const AppImageNetwork(
      {Key? key,
      required this.url,
      this.fit = BoxFit.fill,
      this.isProgress = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isProgress
        ? const CupertinoActivityIndicator()
        : url.startsWith('http')? CachedNetworkImage(
            fit: fit,
            placeholder: (BuildContext context, String url) {
              return const CupertinoActivityIndicator();
            },
            imageUrl: url,
          ): Image.file(File(url), fit: fit);
  }
}
