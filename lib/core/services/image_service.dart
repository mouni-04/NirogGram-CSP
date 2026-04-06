import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<XFile?> pickFromCamera() async {
    return _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
  }

  Future<XFile?> pickFromGallery() async {
    return _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
  }
}
