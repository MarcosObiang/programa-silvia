import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/real_time_parser.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/productViewer/productViewerDataSource.dart';

import 'ProductEntity.dart';

abstract class ProductViewerRepository
    implements
        VariablesDisposer,
        VariablesInitializer,
        RealTImeRepositoryParser {
  late ProductViewerDataSource productViewerDataSource;
  Future<Either<Exception, List<ProductEntity>>> getProducts();
}

class ProductViewerRepositoryImpl implements ProductViewerRepository {
  @override
  StreamController<Map<String, dynamic>> realTimeRepositoryStreamController =
      StreamController();
  @override
  ProductViewerDataSource productViewerDataSource;
  @override
  late StreamSubscription realTimeRepositoryStreamSubscription;

  ProductViewerRepositoryImpl({
    required this.productViewerDataSource,
  });
  @override
  void disposeVariables() {
    realTimeRepositoryStreamController.close();
    realTimeRepositoryStreamController = StreamController();
    realTimeRepositoryStreamSubscription.cancel();
  }

  @override
  Future<Either<Exception, List<ProductEntity>>> getProducts() async {
    try {
      List<ProductEntity> productList = [];
      var data = await productViewerDataSource.getProducts();
      for (int i = 0; i < data.length; i++) {
        productList.add(ProductEntity.fromMap(json: data[i]));
      }
      return Right(productList);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  void initVariables() {
    productViewerDataSource.initVariables();

    repsitoryParser();
  }

  @override
  void repsitoryParser() {
    realTimeRepositoryStreamSubscription = productViewerDataSource
        .productsUpdateStreamController.stream
        .listen((event) {
      var result = ProductEntity.fromMap(json: event["payload"]);

      realTimeRepositoryStreamController
          .add({"eventType": event["eventType"], "payload": result});
    });
  }
}
