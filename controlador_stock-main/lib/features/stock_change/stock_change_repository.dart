import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/real_time_parser.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/productViewer/ProductEntity.dart';
import 'package:stockcontrollerterminal/features/stock_change/stockChangeEntity.dart';
import 'package:stockcontrollerterminal/features/stock_change/stock_change_datasource.dart';

abstract class StockChangerRepository
    implements
        VariablesDisposer,
        VariablesInitializer,
        FromEntity<ProductEntity>,
        RealTImeRepositoryParser {
  late StockChangerDataSource stockChangerDataSource;
  Future<Either<Exception, bool>> changeStock(
      {required List<StockChangeEntity> data,
      required String changedBy,
      required String departmentId});
  Future<Either<Exception, List<StockChangeEntity>>> getProducts();
}

class StockChangerRepositoryImpl implements StockChangerRepository {
  FromEntity<StockChangeEntity> fromEntity;
  ToEntity<StockChangeEntity> toEntity;

  @override
  StockChangerDataSource stockChangerDataSource;

  StockChangerRepositoryImpl(
      {required this.stockChangerDataSource,
      required this.fromEntity,
      required this.toEntity});

  @override
  Future<Either<Exception, bool>> changeStock(
      {required List<StockChangeEntity> data,
      required String changedBy,
      required String departmentId}) async {
    try {
      List<Map<String, dynamic>> parsedStockChanges = [];
      late Map<String, dynamic> result;

      for (StockChangeEntity stockChangeEntity in data) {
        parsedStockChanges.add(
            stockChangeEntity.toJson(stockChangeEntity: stockChangeEntity));
      }

      result = {
        "changedBy": changedBy,
        "departmentId": departmentId,
        "stockUpdate": parsedStockChanges
      };

      await stockChangerDataSource.updateStock(data: result);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  StreamController<Map<String, dynamic>> realTimeRepositoryStreamController =
      StreamController();

  @override
  late StreamSubscription realTimeRepositoryStreamSubscription;

  @override
  void disposeVariables() {
    realTimeRepositoryStreamController.close();
    realTimeRepositoryStreamController = StreamController();
    realTimeRepositoryStreamSubscription.cancel();
  }

  @override
  void initVariables() {
    repsitoryParser();
  }

  @override
  void repsitoryParser() {
    realTimeRepositoryStreamSubscription = stockChangerDataSource
        .productsUpdateStreamController.stream
        .listen((event) {
      String eventType = event["eventType"];

      if (eventType == "addData") {
        var result = StockChangeEntity.fromJson(json: event["payload"]);
        result.changeType = ChangeType.SELECT_CHANGE_TYPE.name;

        realTimeRepositoryStreamController
            .add({"eventType": event["eventType"], "payload": result});
      } else {
        var result = StockChangeEntity.fromJson(json: event["payload"]);

        realTimeRepositoryStreamController
            .add({"eventType": event["eventType"], "payload": result});
      }
    });
  }

  @override
  Map<String, dynamic> toMap(ProductEntity data) {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, List<StockChangeEntity>>> getProducts() async {
    try {
      List<StockChangeEntity> productList = [];
      var data = await stockChangerDataSource.getProducts();
      for (int i = 0; i < data.length; i++) {
        StockChangeEntity stockChangeEntity =
            StockChangeEntity.fromJson(json: data[i]);
        stockChangeEntity.changeType = ChangeType.ADD.name;

        productList.add(stockChangeEntity);
      }
      return Right(productList);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
