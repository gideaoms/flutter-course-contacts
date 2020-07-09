import 'package:contacts/android/views/home.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:flutter/material.dart';

class EditorContactView extends StatefulWidget {
  final ContactModel model;

  EditorContactView({this.model});

  @override
  _EditorContactViewState createState() => _EditorContactViewState();
}

class _EditorContactViewState extends State<EditorContactView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      MaterialPageRoute(
        builder: (context) => HomeView(),
      ),
    );
  }

  onError() {
    final snackBar = SnackBar(
      content: Text('Ops, algo deu errado!'),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: widget.model.id == 0
            ? Text('Novo Contato')
            : Text('Editar Contato'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                initialValue: widget.model?.name,
                onChanged: (value) {
                  widget.model.name = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nome inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.number,
                initialValue: widget.model?.phone,
                onChanged: (value) {
                  widget.model.phone = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                initialValue: widget.model?.email,
                onChanged: (value) {
                  widget.model.email = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: FlatButton.icon(
                  color: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.save,
                    color: Theme.of(context).accentColor,
                  ),
                  label: Text(
                    'Salvar',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: onSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
