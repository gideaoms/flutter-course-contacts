import 'package:camera/camera.dart';
import 'package:contacts/android/views/address.view.dart';
import 'package:contacts/android/views/crop_picture.view.dart';
import 'package:contacts/android/views/editor_contact.view.dart';
import 'package:contacts/android/views/home.view.dart';
import 'package:contacts/android/views/loading.view.dart';
import 'package:contacts/android/views/take_picture.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:contacts/shared/widgets/contact_details_description.widget.dart';
import 'package:contacts/shared/widgets/contact_details_image.widget.dart';
import 'package:flutter/material.dart';
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exclusão de Contato'),
          content: Text('Deseja excluir este contato?'),
          actions: [
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
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
      MaterialPageRoute(
        builder: (context) => HomeView(),
      ),
    );
  }

  onError(err) {
    print(err);
  }

  takePicture() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TakePictureView(
            camera: firstCamera,
          );
        },
      ),
    ).then((imagePath) {
      cropPicture(imagePath);
    });
  }

  cropPicture(path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CropPictureView(
            path: path,
          );
        },
      ),
    ).then((imagePath) {
      updateImage(imagePath);
    });
  }

  updateImage(path) async {
    repository.updateImage(widget.id, path).then((value) {
      setState(() {});
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Contato'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
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
            name: model.name,
            email: model.email,
            phone: model.phone,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(
                  side: BorderSide.none,
                ),
                child: Icon(
                  Icons.phone,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  launch('tel://${model.phone}');
                },
              ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(
                  side: BorderSide.none,
                ),
                child: Icon(
                  Icons.email,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  launch('mailto://${model.email}');
                },
              ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(
                  side: BorderSide.none,
                ),
                child: Icon(
                  Icons.camera_enhance,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: takePicture,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              'Endereço',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.addressLine1 ?? 'Nenhum endereço cadastrado',
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
            isThreeLine: true,
            trailing: FlatButton(
              child: Icon(
                Icons.pin_drop,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressView(),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              color: Color(0xFFFF0000),
              child: FlatButton(
                child: Text(
                  'Excluir contato',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: onDelete,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.edit,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditorContactView(
                  model: model,
                ),
              ));
        },
      ),
    );
  }
}
