import 'package:contacts/ios/views/address.view.dart';
import 'package:contacts/ios/views/editor_contact.view.dart';
import 'package:contacts/ios/views/home.view.dart';
import 'package:contacts/ios/views/loading.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:contacts/shared/widgets/contact_details_description.widget.dart';
import 'package:contacts/shared/widgets/contact_details_image.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsView extends StatefulWidget {
  final int id;

  DetailsView({
    @required this.id,
  });

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final repository = ContactRepository();

  onDelete() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Exclusão de Contato'),
          content: Text('Deseja excluir este contato?'),
          actions: [
            CupertinoButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoButton(
              child: Text('Excluir'),
              onPressed: delete,
            ),
          ],
        );
      },
    );
  }

  delete() {
    repository.delete(widget.id).then((value) {
      onSuccess();
    }).catchError((err) {
      onError(err);
    });
  }

  onSuccess() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomeView(),
      ),
    );
  }

  onError(err) {
    print(err);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: repository.getContact(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ContactModel contact = snapshot.data;
          return page(context, contact);
        }
        return LoadingView();
      },
    );
  }

  Widget page(BuildContext context, ContactModel model) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('Contato'),
            trailing: GestureDetector(
              child: Icon(
                CupertinoIcons.pen,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => EditorContactView(
                      model: model,
                    ),
                  ),
                );
              },
            ),
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                ContactDetailsImage(
                  image: model.image,
                ),
                SizedBox(
                  height: 10,
                ),
                ContactDetailsDescription(
                  phone: model.phone,
                  name: model.name,
                  email: model.email,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CupertinoButton(
                      child: Icon(
                        CupertinoIcons.phone,
                      ),
                      onPressed: () {
                        launch('tel://${model.phone}');
                      },
                    ),
                    CupertinoButton(
                      child: Icon(
                        CupertinoIcons.mail,
                      ),
                      onPressed: () {
                        launch('mailto://${model.email}');
                      },
                    ),
                    CupertinoButton(
                      child: Icon(
                        CupertinoIcons.photo_camera,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                            ),
                            Text(
                              'Endereço',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              model.addressLine1 ??
                                  'Nenhum endereço cadastrado',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              model.addressLine2 ?? '',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        child: Icon(
                          CupertinoIcons.location,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AddressView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton.filled(
                  child: Text('Excluir Contato'),
                  onPressed: onDelete,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
