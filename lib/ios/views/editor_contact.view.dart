import 'package:contacts/ios/views/home.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:flutter/cupertino.dart';

class EditorContactView extends StatefulWidget {
  final ContactModel model;

  EditorContactView({this.model});

  @override
  _EditorContactViewState createState() => _EditorContactViewState();
}

class _EditorContactViewState extends State<EditorContactView> {
  final _formKey = GlobalKey<FormState>();
  final _repository = ContactRepository();

  onSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (widget.model.id == 0)
      create();
    else
      update();
  }

  create() {
    widget.model.id = null;
    widget.model.image = null;

    _repository.create(widget.model).then((value) {
      onSuccess();
    }).catchError((err) {
      onError();
    });
  }

  update() {
    _repository.update(widget.model).then((value) {
      onSuccess();
    }).catchError((err) {
      onError();
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

  onError() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Falha na operação'),
          content: Text('Ops, parece que algo deu errado'),
          actions: [
            CupertinoButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: widget.model.id == 0
                ? Text('Novo Contato')
                : Text('Editar Contato'),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CupertinoTextField(
                      placeholder: widget.model?.name ?? 'Nome',
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        widget.model.name = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoTextField(
                      placeholder: widget.model?.phone ?? 'Telefone',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        widget.model.phone = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoTextField(
                      placeholder: widget.model?.email ?? 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        widget.model.email = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: CupertinoButton.filled(
                        child: Text('Salvar'),
                        onPressed: onSubmit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
