import 'dart:io';

import 'package:contacts/shared/styles.dart';
import 'package:flutter/widgets.dart';

class ContactDetailsImage extends StatelessWidget {
  final String image;

  ContactDetailsImage({
    @required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: basePrimaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(200),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image == null
                ? AssetImage('assets/images/profile-picture.png')
                : FileImage(File(image)),
          ),
        ),
      ),
    );
  }
}
