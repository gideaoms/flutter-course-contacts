import 'dart:io';
import 'package:contacts/android/views/details.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:flutter/material.dart';

class ContactListItem extends StatelessWidget {
  final ContactModel model;

  ContactListItem({
    @required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: model.image == null
                ? AssetImage('assets/images/profile-picture.png')
                : FileImage(File(model.image)),
          ),
        ),
      ),
      title: Text(model.name),
      subtitle: Text(model.phone),
      trailing: FlatButton(
        child: Icon(
          Icons.person,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailsView(
                  id: model.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
