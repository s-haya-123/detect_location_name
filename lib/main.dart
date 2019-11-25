import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:detect_location_name/CameraModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

List<CameraDescription> cameras;

// 実行されるmain関数
Future<Null> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {}
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: ScopedModel<CameraModel>(
            model: CameraModel(cameras[0]), child: _MyHomePageState())
    );
  }
}

class _MyHomePageState extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CameraModel>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              _thumbnailWidget(model),
              _cameraWidget(model),
              _regionName(model),
            ],
          ),
        );
      },
    );
  }
  Widget _regionName(CameraModel model) {
    return model.isShowRegion ? Stack(children: [
      Center(child:
          Image.asset('images/title.png',
              height: 100,
              width: 380,
              fit:BoxFit.fill,),
        ),
      Center(
        child:
          Text(
              '仙峰寺',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 60,
                fontFamily: 'aoyagi'
              )
          ),
      )
    ]): Stack(children: [],);
  }
  Widget _thumbnailWidget(CameraModel model) {
    return Positioned.fill(
      child:  !isStartCamera(model)
          ? Container(
        color: Colors.blue,
      )
          : _takedPictureWidget(model),
    );
  }
  Widget _cameraWidget(CameraModel model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child:
      RaisedButton(
        color: Colors.green,
        onPressed: () async {
          final audio = AssetsAudioPlayer();
          await audio.open(AssetsAudio(
            asset: "drum-japanese2.mp3",
            folder: "audio/",
          ));
          await audio.play();
          print(audio.finished);
          model.startCameraPreview();
          model.showRegion();
        },
        child: Text(
          "START",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  Widget _takedPictureWidget(CameraModel model) {
    return ScopedModelDescendant<CameraModel>(
      builder: (context, child, model) {
        return  AspectRatio(
          aspectRatio: model.controller.value.aspectRatio,
          child: new CameraPreview(model.controller),
        );
      },
    );
  }
  bool isStartCamera(CameraModel model){
    return model.controller != null && model.controller.value.isInitialized;
  }
}
