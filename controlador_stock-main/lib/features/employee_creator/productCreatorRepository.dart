import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/employee_creator/productCreatorDataSource.dart';

abstract class ProductCreatorRepository {
  late FromEntity fromEntity;
  late ProductCreatorDataSource productCreatorDataSource;

  Future<Either<Exception, bool>> createProduct(
      {required Map<String, dynamic> productData});
}

class ProductCreatorRepositoryImpl implements ProductCreatorRepository {
  @override
  FromEntity fromEntity;
  @override
  ProductCreatorDataSource productCreatorDataSource;

  ProductCreatorRepositoryImpl(
      {required this.fromEntity, required this.productCreatorDataSource});

  @override
  Future<Either<Exception, bool>> createProduct(
      {required Map<String, dynamic> productData}) async {
    try {
      await productCreatorDataSource.createProdcut(data: productData);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
