import 'package:image_picker/image_picker.dart';

import './services.dart';

class CameraGalleryServiceImpl implements CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    // Pick an image.
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if( photo == null ) return null;

    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    // Capture a photo.
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear
    );

    if( photo == null ) return null;

    return photo.path;
  }
  
}