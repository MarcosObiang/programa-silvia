import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/service.dart';
import 'package:stockcontrollerterminal/Utils/services/ImagePicker/image_picker_repository.dart';

abstract class ImagePickerService implements Service {
  late ImagePickerRepository imagePickerRepository;

  Future<Either<Exception, Uint8List>> getImage();
}

class ImagePickerServiceImpl implements ImagePickerService {
  @override
  ImagePickerRepository imagePickerRepository;

  ImagePickerServiceImpl({required this.imagePickerRepository});

  @override
  Future<Either<Exception, Uint8List>> getImage() async {
    return await imagePickerRepository.getImage();
  }
}
