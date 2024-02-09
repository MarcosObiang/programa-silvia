import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockcontrollerterminal/Utils/dialogs/dialogs_file.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Presenter.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/presenter_should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/productViewer/ProductEntity.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/Widgets/Screen.dart';
import 'package:stockcontrollerterminal/features/stock_change/presentation/Widgets/Screen.dart';
import 'package:stockcontrollerterminal/features/stock_change/stock_change_controller.dart';

enum ChangeStockProcessState { loading, not_loading }

class StockChangerPresentationManager
    with ChangeNotifier
    implements
        PresenterLayer,
        VariablesDisposer,
        VariablesInitializer,
        PresenterShouldUpdate {
  StockChangerPresentationManager({required this.stockChangerController});

  @override
  ControllerState state = ControllerState.ready;
  StockChangerController stockChangerController;
  ChangeStockProcessState changeStockProcessState =
      ChangeStockProcessState.not_loading;

  set setChnageStockProcessState(
      ChangeStockProcessState changeStockProcessState) {
    this.changeStockProcessState = changeStockProcessState;
    notifyListeners();
  }

  set setControllerState(ControllerState newState) {
    state = newState;
    notifyListeners();
  }

  @override
  late StreamSubscription<Map<String, dynamic>> presenterUpdateDataSubscription;

  void changeStock(
      {required String changedBy, required String departmentId}) async {
    setChnageStockProcessState = ChangeStockProcessState.loading;
    var result = await stockChangerController.changeStock(
        changedBy: changedBy, departmentId: departmentId);
    result.fold((l) {
      setChnageStockProcessState = ChangeStockProcessState.not_loading;

      if (l is NetworkException) {
        PresentationDialogs().showErrorDialog(
            title: "Error",
            content: "No hay conexion a internet",
            context: maincontext);
      } else {
        PresentationDialogs().showErrorDialog(
            title: "Error",
            content: "Hubo un error al realizar la operación ",
            context: maincontext);
      }
    }, (r) {
      PresentationDialogs().showErrorDialogWithOptions(
          dialogTitle: "Exito",
          dialogText: "El producto ha sido actualizado ",
          dialogOptionsList: [
            DialogOptions(
                function: () => Navigator.pop(maincontext), text: "Aceptar")
          ],
          context: maincontext);
      setChnageStockProcessState = ChangeStockProcessState.not_loading;
    });
  }

  void selectProductsToChange({required List<String> productsToChange}) {
    stockChangerController.selectProductsToChange(
        productsToBeChanged: productsToChange);
  }

  void unselectProductsToChange() {
    stockChangerController.unselectProductsToChange();
  }

  bool wasNameEmpty(String name) {
    if (name.isEmpty) {
      PresentationDialogs().showErrorDialog(
          title: "Error",
          content:
              "El campo '¿Quien añade los productos?' no puede estar vacio ",
          context: maincontext);
      return false;
    } else {
      return true;
    }
  }

  bool containsNumbers(String name) {
    bool result = false;
    if (name.contains(RegExp("[0-9]"))) {
      result = false;
      PresentationDialogs().showErrorDialog(
          title: "Error",
          content:
              "El campo '¿Quien añade los productos?' no puede contener numeros",
          context: maincontext);
    } else {
      result = true;
    }
    return result;
  }

  bool numberFieldIsEmpty(String number) {
    bool result = false;
    if (number.isEmpty) {
      result = false;

      PresentationDialogs().showErrorDialog(
          title: "Error",
          content:
              "El campo '¿Cuantos productos vas a añadir?' no puede estar vacio",
          context: maincontext);
    } else {
      result = true;
    }
    return result;
  }

  bool numberFieldGreaterThanZero(String number) {
    bool result = false;
    int value = int.parse(number);
    if (value <= 0) {
      result = false;

      PresentationDialogs().showErrorDialog(
          title: "Error",
          content:
              "El campo '¿Cuantos productos vas a añadir?' debe contener un valor mayor a cero",
          context: maincontext);
    } else {
      result = true;
    }
    return result;
  }

  @override
  void disposeVariables() {
    stockChangerController.disposeVariables();
    setControllerState = ControllerState.notLoaded;
    presenterUpdateDataSubscription.cancel();
  }

  @override
  void initVariables() {
    presenterUpdate();

    stockChangerController.initVariables();
  }

  @override
  void presenterUpdate() {
    presenterUpdateDataSubscription =
        stockChangerController.updateController.stream.listen((event) {
      notifyListeners();
    });
  }
}
