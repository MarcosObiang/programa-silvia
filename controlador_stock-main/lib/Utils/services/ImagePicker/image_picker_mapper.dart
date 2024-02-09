import 'dart:typed_data';

import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';

class ImagePickerMapper implements ToEntity<Uint8List> {
  @override
  Uint8List fromMap({required Map data}) {
    Uint8List uint8list = data["data"];
    return uint8list;
  }
}
