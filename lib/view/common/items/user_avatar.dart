import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hide_out/utils/constants.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.url,
    this.radius = 40.0,
    this.file,
  });

  final double radius;
  final String? url;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400)),
            child: file != null
                ? CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.black12,
                    foregroundImage: FileImage(file!),
                  )
                : CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.black12,
                    foregroundImage: CachedNetworkImageProvider(url ?? userIconUrl),
                  )),
      ],
    );
  }
}
