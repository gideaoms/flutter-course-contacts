import 'package:contacts/android/views/home.view.dart';
import 'package:contacts/controllers/auth.controler.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final controller = AuthController();

  @override
  void initState() {
    super.initState();

    controller.authenticate().then((isAuthenticated) {
      print('auth $isAuthenticated');
      if (isAuthenticated == true) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return HomeView();
          }),
        );
      } else {
        // TODO: msg to user
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          Icon(
            Icons.fingerprint,
            size: 72,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Meus Contatos',
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
