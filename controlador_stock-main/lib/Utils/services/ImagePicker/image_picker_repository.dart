import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/services/ImagePicker/image_picker_data_source.dart';

abstract class ImagePickerRepository {
  late ToEntity<Uint8List> toEntity;
  late ImageGetterDataSource imageGetterDataSource;
  Future<Either<Exception, Uint8List>> getImage();
}

class ImagePickerRepoImpl implements ImagePickerRepository {
  @override
  ToEntity<Uint8List> toEntity;
  @override
  ImageGetterDataSource imageGetterDataSource;

  ImagePickerRepoImpl(
      {required this.toEntity, required this.imageGetterDataSource});

  @override
  Future<Either<Exception, Uint8List>> getImage() async {
    try {
      var data = await imageGetterDataSource.getImageFromSource();
      Uint8List uint8list = toEntity.fromMap(data: data);
      return Right(uint8list);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
