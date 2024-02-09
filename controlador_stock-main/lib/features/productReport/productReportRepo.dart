import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/productReport/productRepoEntity.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportDataSource.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportMapper.dart';
import 'package:stockcontrollerterminal/features/productViewer/ProductEntity.dart';

abstract class ProductReportRepo {
  late ProductReportDataSource productReportDataSource;
  Future<Either<Exception, ProductReportEntity>> getReport(
      {required String productId,
      required DateTime? fromDate,
      required DateTime? toDate,
      required int offset});
  late ProductReportMapper productReportMapper;
}

class ProductReportRepoImpl implements ProductReportRepo {
  @override
  ProductReportDataSource productReportDataSource;
  @override
  ProductReportMapper productReportMapper;
  ProductReportRepoImpl(
      {required this.productReportDataSource,
      required this.productReportMapper});

  @override
  Future<Either<Exception, ProductReportEntity>> getReport(
      {required String productId,
      required DateTime? fromDate,
      required DateTime? toDate,
      required int offset}) async {
    try {
      var data = await productReportDataSource.getProductsReport(
          productId: productId,
          fromDate: fromDate as DateTime,
          toDate: toDate as DateTime,
          offset: offset);
      ProductReportEntity productReportEntity =
          productReportMapper.fromMap(data: data);

      return Right(productReportEntity);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
