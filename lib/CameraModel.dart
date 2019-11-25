import 'dart:async';

import 'package:camera/camera.dart';
import 'package:detect_location_name/Location.dart';
import 'package:scoped_model/scoped_model.dart';

class CameraModel extends Model {
  bool isShowRegion = false;
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
    Location().detectLocale(34.50165844222924, 133.3843445777893);
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

}