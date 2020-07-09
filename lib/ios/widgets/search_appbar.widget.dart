import 'package:contacts/controllers/home.controller.dart';
import 'package:contacts/ios/views/editor_contact.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchAppbar extends StatefulWidget with ObstructingPreferredSizeWidget {
  final HomeController controller;

  SearchAppbar({
    @required this.controller,
  });

  @override
  _SearchAppbarState createState() => _SearchAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(52);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}

class _SearchAppbarState extends State<SearchAppbar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Observer(
        builder: (context) {
          return widget.controller.showSearch
              ? CupertinoTextField(
                  autofocus: true,
                  placeholder: 'Pesquisar...',
                  onSubmitted: (value) {
                    widget.controller.search(value);
                  },
                )
              : Text('Meus Contatos');
        },
      ),
      leading: Observer(
        builder: (context) {
          return GestureDetector(
            child: Icon(
              widget.controller.showSearch
                  ? CupertinoIcons.clear
                  : CupertinoIcons.search,
            ),
            onTap: () {
              if (widget.controller.showSearch) widget.controller.search('');

              widget.controller.toggleSearch();
            },
          );
        },
      ),
      trailing: GestureDetector(
        child: Icon(
          CupertinoIcons.add,
        ),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) {
              return EditorContactView(
                model: ContactModel(
                  id: 0,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
