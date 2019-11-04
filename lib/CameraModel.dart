import 'package:camera/camera.dart';
import 'package:scoped_model/scoped_model.dart';

class CameraModel extends Model {
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
    notifyListeners();
  }

}