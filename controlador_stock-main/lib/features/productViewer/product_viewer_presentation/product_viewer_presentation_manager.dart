import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stockcontrollerterminal/Utils/dialogs/dialogs_file.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/departments/presentation/widgets/screen.dart';
import 'package:stockcontrollerterminal/features/employee_creator/productCreatorController.dart';
import 'package:stockcontrollerterminal/features/productViewer/ProductEntity.dart';
import 'package:stockcontrollerterminal/features/productViewer/productViewerController.dart';
import 'package:stockcontrollerterminal/features/stock_change/presentation/Widgets/Screen.dart';

import '../../../Utils/interfaces/Presenter.dart';
import '../../../Utils/interfaces/presenter_should_update.dart';
import '../../../Utils/interfaces/variables_disposer.dart';
import '../../../Utils/interfaces/variables_initializer.dart';
import 'Widgets/Screen.dart';

enum ProductViewerState {
  loading,
  not_loading,
  no_internet,
  error,
  ready,
  empty,
}

class ProductViewerPresentationManager
    with ChangeNotifier
    implements
        PresenterLayer,
        VariablesDisposer,
        VariablesInitializer,
        PresenterShouldUpdate {
  ProductViewerController productViewerController;

  ProductViewerPresentationManager({required this.productViewerController});

  @override
  late StreamSubscription<Map<String, dynamic>> presenterUpdateDataSubscription;

  @override
  ControllerState state = ControllerState.notLoaded;

  ProductViewerState _productViewerState = ProductViewerState.not_loading;

  ProductViewerState get productViewerState => _productViewerState;

  set setProductViewerState(ProductViewerState newState) {
    _productViewerState = newState;
    notifyListeners();
  }

  set setControllerState(ControllerState newState) {
    state = newState;
    notifyListeners();
  }

  @override
  void disposeVariables() {
    productViewerController.disposeVariables();
    setControllerState = ControllerState.notLoaded;
    presenterUpdateDataSubscription.cancel();
  }

  void getProducts() async {
    var result = await productViewerController.getProducts();
    result.fold((l) {
      if (l is NetworkException) {
        setProductViewerState = ProductViewerState.no_internet;
        PresentationDialogs.instance.showNetworkErrorDialog(
          context: maincontext,
        );
      } else {
        setProductViewerState = ProductViewerState.error;
        PresentationDialogs.instance.showErrorDialog(
          context: maincontext,
          title: "Error",
          content: l.toString(),
        );
      }
    }, (r) => null);
  }

  @override
  void initVariables() {
    productViewerController.initVariables();
    getProducts();
    presenterUpdate();
  }

  @override
  void presenterUpdate() {
    presenterUpdateDataSubscription =
        productViewerController.updateController.stream.listen((event) {
      notifyListeners();
    });
  }

  void updateProductList() {}

  void _showStockChangeDialog({required List<String> productId}) {
    Navigator.of(maincontext).push(MaterialPageRoute(builder: (context) {
      return StockChangerScreen(
        productsToChange: productId,
      );
    }));
  }

  void showStockChangeDialogWithMultipleProducts() {
    Navigator.of(maincontext).push(MaterialPageRoute(builder: (context) {
      return StockChangerScreen(
        productsToChange: productViewerController.getSelectedProducts(),
      );
    }));
  }

  void showStockUpdateOptions({required List<String> productId}) {
    _showStockChangeDialog(productId: productId);
  }
}
