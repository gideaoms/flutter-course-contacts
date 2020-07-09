import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class TakePictureView extends StatefulWidget {
  final CameraDescription camera;

  TakePictureView({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _TakePictureViewState createState() => _TakePictureViewState();
}

class _TakePictureViewState extends State<TakePictureView> {
  CameraController controller;
  Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<String> takePhoto() async {
    try {
      await initializeControllerFuture;

      final uuid = Uuid();
      final fileName = '${uuid.v4()}.jpg';
      final path = join(
        (await getTemporaryDirectory())
            .path, // essa é temporária, a verdadeira é aquela com crop
        fileName,
      );

      await controller.takePicture(path);
      return path;
    } catch (err) {
      print(err);
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Imagem'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: initializeControllerFuture,
        builder: (context, snapshop) {
          if (snapshop.connectionState == ConnectionState.done) {
            return CameraPreview(controller);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.camera,
        ),
        onPressed: () {
          takePhoto().then((path) {
            Navigator.pop(context, path);
          });
        },
      ),
    );
  }
}
