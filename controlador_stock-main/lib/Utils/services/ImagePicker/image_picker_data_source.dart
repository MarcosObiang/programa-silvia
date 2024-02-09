import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';

abstract class ImageGetterDataSource {
  Future<Map<String,dynamic>> getImageFromSource();
}

class ImageGetterDataSourceImpl implements ImageGetterDataSource {
  @override
  Future<Map<String,dynamic>> getImageFromSource() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        return {"data":image.readAsBytes()};
      } else {
        throw MediaFileException(message: "IMAGE_NOT_CHOOSEN");
      }
    } catch (e) {
      throw MediaFileException(message: e.toString());
    }
  }
}
