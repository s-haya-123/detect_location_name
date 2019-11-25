import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:detect_location_name/Location.dart';
import 'package:scoped_model/scoped_model.dart';

class CameraModel extends Model {
  bool isShowRegion = false;
  String title='';
  CameraController controller;
  CameraDescription cameras;
  CameraModel(this.cameras){
  }

  void startCameraPreview() async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new CameraController(cameras, ResolutionPreset.high);
    controller.addListener(() {
      notifyListeners();
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
    }
    Location().detectLocale(34.50165844222924, 133.3843445777893).then((entity) async {
      setTitle(entity);
      final audio = AssetsAudioPlayer();
      await audio.open(AssetsAudio(
        asset: "drum-japanese2.mp3",
        folder: "audio/",
      ));
      await audio.play();
      print(audio.finished);
      showRegion();
    });
    notifyListeners();
  }
  void showRegion() {
    this.isShowRegion = true;
    Timer.periodic(Duration(seconds:5), (Timer t) {
      this.isShowRegion = false;
      notifyListeners();
    });
    notifyListeners();
  }
  void setTitle(LocationEntity entity) {
    this.title = '${entity.prefecture.name}${entity.municipality.name}';
    notifyListeners();
  }

}