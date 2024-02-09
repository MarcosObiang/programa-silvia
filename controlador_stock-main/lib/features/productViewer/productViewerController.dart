import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'ProductEntity.dart';
import 'package:stockcontrollerterminal/features/productViewer/productViewerRepository.dart';

abstract class ProductViewerController
    implements
        ControllerLayer,
        VariablesDisposer,
        VariablesInitializer,
        ShouldUpdate {
  late ProductViewerRepository productViewerRepository;
  Future<Either<Exception, List<ProductEntity>>> getProducts();
  List<Map<String, dynamic>> suggestionsList = [];
  List<String> getSelectedProducts();
  late List<ProductEntity> productsList;
  void selectProduct({required String idProduct});
  void selectAllProducts();
  void unselectAllProducts();
  void unselectProduct({required String idProduct});
  void searchSuggestions({required String input});
  void putSuggestionFirst({required String productId});
}

class ProductViewerControllerImpl implements ProductViewerController {
  @override
  StreamController<Map<String, dynamic>> updateController = StreamController();
  @override
  List<ProductEntity> productsList = [];
  @override
  ProductViewerRepository productViewerRepository;

  @override
  ControllerState state = ControllerState.notLoaded;

  late StreamSubscription streamSubscription;
  @override
  List<Map<String, dynamic>> suggestionsList = [];

  ProductViewerControllerImpl({
    required this.productViewerRepository,
  });
  @override
  void disposeVariables() {
    productsList = List.empty(growable: true);
    state = ControllerState.notLoaded;
    if (updateController.isClosed == false) {
      updateController.close();
    }
    streamSubscription.cancel();
  }

  @override
  void initVariables() {
    productViewerRepository.initVariables();
    _repositoryListener();
  }

  @override
  Future<Either<Exception, List<ProductEntity>>> getProducts() async {
    var products = await productViewerRepository.getProducts();
    products.fold((l) => null, (r) => productsList.addAll(r));

    sendUpdateData();
    return products;
  }

  void unselectAllProducts() {
    for (int i = 0; i < productsList.length; i++) {
      productsList[i].productSelected = false;
    }
    sendUpdateData();
  }

  void selectAllProducts() {
    for (int i = 0; i < productsList.length; i++) {
      productsList[i].productSelected = true;
    }
    sendUpdateData();
  }

  void selectProduct({required String idProduct}) {
    for (int i = 0; i < productsList.length; i++) {
      if (productsList[i].productId == idProduct) {
        productsList[i].productSelected = true;
        break;
      }
    }
    sendUpdateData();
  }

  void unselectProduct({required String idProduct}) {
    for (int i = 0; i < productsList.length; i++) {
      if (productsList[i].productId == idProduct) {
        productsList[i].productSelected = false;
        break;
      }
    }
    sendUpdateData();
  }

  List<String> getSelectedProducts() {
    List<String> result = [];

    for (ProductEntity productEntity in productsList) {
      if (productEntity.productSelected != null) {
        if (productEntity.productSelected!) {
          result.add(productEntity.productId);
        }
      }
    }
    return result;
  }

  void _repositoryListener() {
    streamSubscription = productViewerRepository
        .realTimeRepositoryStreamController.stream
        .listen((event) {
      String eventType = event["eventType"];
      ProductEntity productFromRepository = event["payload"];
      if (eventType == "addData") {
        productsList.add(productFromRepository);
        updateController.add({"event": "update", "state": state});
      }
      if (eventType == "removeData") {
        updateController.add({"event": "update", "state": state});
        for (int i = 0; i < productsList.length; i++) {
          if (productsList[i].productId == productFromRepository.productId) {
            int whereToRemove = productsList.indexWhere((element) =>
                element.productId == productFromRepository.productId);

            productsList.removeAt(whereToRemove);
            break;
          }
        }
      }
      if (eventType == "updateData") {
        for (int i = 0; i < productsList.length; i++) {
          if (productsList[i].productId == productFromRepository.productId) {
            productsList[i] = productFromRepository;
            break;
          }
        }
      }
      sendUpdateData();
    });
  }

  @override
  void sendUpdateData() {
    updateController.add({"event": "update", "state": state});
  }

  @override
  void putSuggestionFirst({required String productId}) {
    for (int i = 0; i < productsList.length; i++) {
      if (productsList[i].productId == productId) {
        ProductEntity product = productsList.removeAt(i);
        productsList.insert(0, product);
        break;
      }
    }
    sendUpdateData();
  }

  @override
  void searchSuggestions({required String input}) {
    suggestionsList.clear();
    List<Map<String, dynamic>> dataList = [];
    for (int i = 0; i < productsList.length; i++) {
      if (productsList[i]
          .productName
          .toLowerCase()
          .contains(input.toLowerCase())||productsList[i]
          .productId
          .toLowerCase()
          .contains(input.toLowerCase())) {
        dataList.add({
          "productName": productsList[i].productName,
          "productId": productsList[i].productId
        });
      }
    }
    suggestionsList.addAll(dataList);
    ();
  }
}
