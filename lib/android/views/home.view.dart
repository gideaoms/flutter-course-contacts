import 'package:contacts/android/views/details.view.dart';
import 'package:contacts/android/views/editor_contact.view.dart';
import 'package:contacts/android/widgets/contact_list_item.view.dart';
import 'package:contacts/android/widgets/search_appbar.widget.dart';
import 'package:contacts/controllers/home.controller.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();

    controller.search('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: SearchAppBar(
          controller: controller,
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: Observer(
        builder: (context) {
          return ListView.builder(
            itemCount: controller.contacts.length,
            itemBuilder: (context, index) {
              return ContactListItem(
                model: controller.contacts[index],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditorContactView(
                model: ContactModel(
                  id: 0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
