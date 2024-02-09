import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/departments/departmentController.dart';
import 'package:stockcontrollerterminal/features/stock_change/stockChangeEntity.dart';
import 'package:stockcontrollerterminal/features/stock_change/stock_change_repository.dart';

abstract class StockChangerController
    implements
        ControllerLayer,
        VariablesDisposer,
        VariablesInitializer,
        ShouldUpdate {
  late List<StockChangeEntity> productStockChangeList;
  late StockChangerRepository stockChangerRepository;
  late DepartmentController departmentController;
  late List<Map<String, dynamic>> departmentSearchSuggestions;

  Future<Either<Exception, bool>> changeStock(
      {required String changedBy, required String departmentId});

  void selectProductsToChange({required List<String> productsToBeChanged});
  void searchDepartment({required String departmentName});
  void unselectProductsToChange();
}

class StockChangerControllerImpl implements StockChangerController {
  StockChangerControllerImpl(
      {required this.stockChangerRepository,
      required this.departmentController});
  late StreamSubscription streamSubscription;
  @override
  List<Map<String, dynamic>> departmentSearchSuggestions = [];
  @override
  DepartmentController departmentController;
  @override
  List<StockChangeEntity> productStockChangeList = [];
  @override
  StockChangerRepository stockChangerRepository;
  @override
  ControllerState state = ControllerState.notLoaded;

  @override
  StreamController<Map<String, dynamic>> updateController = StreamController();

  @override
  Future<Either<Exception, bool>> changeStock(
      {required String changedBy, required String departmentId}) async {
    try {
      Exception? exception;

      var result = await stockChangerRepository.changeStock(
          data: productStockChangeList
              .where((value) => value.productSelectedToBeChanged == true)
              .toList(),
          changedBy: changedBy,
          departmentId: departmentId);

      result.fold((l) => exception = l, (r) => null);

      if (exception != null) {
        return Left(exception!);
      } else {
        return const Right(true);
      }
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  void disposeVariables() {
    productStockChangeList = List.empty(growable: true);
    state = ControllerState.notLoaded;
    if (updateController.isClosed == false) {
      updateController.close();
    }
    streamSubscription.cancel();
  }

  @override
  void initVariables() {
    departmentSearchSuggestions = departmentController.suggestionsList;
    stockChangerRepository.initVariables();
    getProducts();
    _repositoryListener();
  }

  @override
  void sendUpdateData() {
    updateController.add({"event": "update", "state": state});
  }

  @override
  void searchDepartment({required String departmentName}) {
    departmentController.searchSuggestions(input: departmentName);
    sendUpdateData();
  }

  @override
  void selectProductsToChange({required List<String> productsToBeChanged}) {
    for (String productId in productsToBeChanged) {
      for (int i = 0; i < productStockChangeList.length; i++) {
        if (productId == productStockChangeList[i].productId) {
          productStockChangeList[i].productSelectedToBeChanged = true;
          var removedStockEntity = productStockChangeList.removeAt(i);
          productStockChangeList.insert(0, removedStockEntity);
        }
      }
    }
  }

  void unselectProductsToChange() {
    for (StockChangeEntity stockChangeEntity in productStockChangeList) {
      stockChangeEntity.productSelectedToBeChanged = false;
    }
  }

  void _repositoryListener() {
    streamSubscription = stockChangerRepository
        .realTimeRepositoryStreamController.stream
        .listen((event) {
      String eventType = event["eventType"];
      StockChangeEntity stockChangeDataEntity = event["payload"];
      if (eventType == "addData") {
        productStockChangeList.add(stockChangeDataEntity);
        updateController.add({"event": "update", "state": state});
      }
      if (eventType == "removeData") {
        updateController.add({"event": "update", "state": state});
        for (int i = 0; i < productStockChangeList.length; i++) {
          if (productStockChangeList[i].productId ==
              stockChangeDataEntity.productId) {
            int whereToRemove = productStockChangeList.indexWhere((element) =>
                element.productId == stockChangeDataEntity.productId);

            productStockChangeList.removeAt(whereToRemove);
            break;
          }
        }
      }
      if (eventType == "updateData") {
        for (int i = 0; i < productStockChangeList.length; i += 1) {
          if (productStockChangeList[i].productId ==
              stockChangeDataEntity.productId) {
            productStockChangeList[i] = stockChangeDataEntity;
            break;
          }
        }
      }
      sendUpdateData();
    });
  }

  Future<Either<Exception, List<StockChangeEntity>>> getProducts() async {
    var products = await stockChangerRepository.getProducts();
    products.fold((l) => null, (r) => productStockChangeList.addAll(r));

    sendUpdateData();
    return products;
  }
}
