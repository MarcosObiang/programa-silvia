import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stockcontrollerterminal/Utils/dialogs/dialogs_file.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Presenter.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/presenter_should_update.dart';
import 'package:stockcontrollerterminal/features/employee_creator/productCreatorController.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/Widgets/Screen.dart';

import '../../../Utils/interfaces/variables_disposer.dart';
import '../../../Utils/interfaces/variables_initializer.dart';

enum CreateProductProcessState {
  loading,
  not_loadiing,
}

class ProductCreatorPresentatorManager
    with ChangeNotifier
    implements
        PresenterLayer,
        VariablesDisposer,
        VariablesInitializer,
        PresenterShouldUpdate {
  ProductCreatorController productCreatorcontroller;
  @override
  late StreamSubscription<Map<String, dynamic>> presenterUpdateDataSubscription;
  @override
  ControllerState state = ControllerState.notLoaded;

  CreateProductProcessState createProductProcessState =
      CreateProductProcessState.not_loadiing;

  set setCreateProductProcessState(
      CreateProductProcessState createProductProcessState) {
    this.createProductProcessState = createProductProcessState;
    notifyListeners();
  }

  ProductCreatorPresentatorManager({required this.productCreatorcontroller});

  @override
  void disposeVariables() {
    productCreatorcontroller.disposeVariables();
    presenterUpdateDataSubscription.cancel();
  }

  @override
  void initVariables() {
    productCreatorcontroller.initVariables();
    presenterUpdate();
  }

  @override
  void presenterUpdate() {
    presenterUpdateDataSubscription =
        productCreatorcontroller.updateController.stream.listen((event) {
      if (event["state"] is ControllerState) {
        state = event["state"];
      }
    });
  }

  void createProduct(
      {required String productName,
      required String productId,
      required int productCount}) async {
    setCreateProductProcessState = CreateProductProcessState.loading;

    var result = await productCreatorcontroller.createProduct(datosEmpleado: {
      "productName": productName,
      "productId": productId,
      "productCount": productCount
    });

    result.fold((l) {
      setCreateProductProcessState = CreateProductProcessState.not_loadiing;

      if (l is NetworkException) {
        PresentationDialogs.instance.showGenericDialog(
            content: "Error de conexion", title: "error", context: maincontext);
      } else {
        PresentationDialogs.instance.showGenericDialog(
            content: "Error al realizar la operacion ",
            title: "error",
            context: maincontext);
      }
    }, (r) {
      setCreateProductProcessState = CreateProductProcessState.not_loadiing;
      PresentationDialogs.instance.showGenericDialog(
          content: "El producto se ha añadido correctamente al inventario ",
          title: "Nuevo producto",
          context: maincontext);
    });
  }
}
