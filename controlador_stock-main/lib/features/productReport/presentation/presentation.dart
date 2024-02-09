import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stockcontrollerterminal/Utils/dialogs/dialogs_file.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Presenter.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/presenter_should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportController.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/Widgets/Screen.dart';

enum CreateProductReportState {
  loading,
  not_loadiing,
}

class ProductReportCreatorPresentationManager
    with ChangeNotifier
    implements
        PresenterLayer,
        VariablesDisposer,
        VariablesInitializer,
        PresenterShouldUpdate {
  ProductReportController productReportController;
  CreateProductReportState createProductReportState =
      CreateProductReportState.not_loadiing;

  ProductReportCreatorPresentationManager(
      {required this.productReportController});

  set setCreateProductReportState(
      CreateProductReportState createProductReportState) {
    this.createProductReportState = createProductReportState;
    notifyListeners();
  }

  @override
  late StreamSubscription<Map<String, dynamic>> presenterUpdateDataSubscription;

  @override
  ControllerState state = ControllerState.notLoaded;

  @override
  void disposeVariables() {
    productReportController.disposeVariables();
    presenterUpdateDataSubscription.cancel();
  }

  @override
  void initVariables() {
    productReportController.initVariables();
    presenterUpdate();
  }

  @override
  void presenterUpdate() {
    presenterUpdateDataSubscription =
        productReportController.updateController.stream.listen((event) {
      if (event["state"] is ControllerState) {
        state = event["state"];
      }
    });
  }

  void clearReports() {
    productReportController.clearReportMemory();
  }

  void getMoreReports(
      {required String productId,
      required DateTime fromDate,
      required DateTime toDate}) async {
    setCreateProductReportState = CreateProductReportState.loading;

    var result = await productReportController.getMoreReports(
        productId: productId, fromDate: fromDate, toDate: toDate);
    result.fold((l) {
      setCreateProductReportState = CreateProductReportState.not_loadiing;

      if (l is GenericException) {
        if (l.message == "NO_REPORTS_FOUND") {
          PresentationDialogs.instance.showGenericDialog(
              content:
                  "No hay mas detalles que cargar sobre este producto en este tramo de tiempo,",
              context: maincontext,
              title: "Error");
        } else {
          PresentationDialogs.instance.showGenericDialog(
            context: maincontext,
            title: "Error",
            content:
                "Ha habido un error al intentar cargar mas detalles, porfavor intentelo de nuevo, o vuelva a solicitar el informe, si el problema persiste contacte con el administrador",
          );
        }
      }
    }, (r) {
      setCreateProductReportState = CreateProductReportState.not_loadiing;
      PresentationDialogs.instance.showGenericDialog(
        context: maincontext,
        title: "Exito",
        content:
            "Se han cargado mas detalles sobre este producto en este tramo de tiempo",
      );
    });
  }

  void getProductReport(
      {required String productId,
      required DateTime? fromDate,
      required DateTime? toDate}) async {
    setCreateProductReportState = CreateProductReportState.loading;

    var result = await productReportController.getProductReprot(
        productId: productId, fromDate: fromDate, toDate: toDate);
    result.fold((l) {
      if (l is GenericException) {
        if (l.message == "THIS_REPORT_ALREADY_EXISTS_IN_MEMORY") {
          PresentationDialogs.instance.showGenericDialog(
              content:
                  "El reporte solicitado ya existe, compruebe las fechas e intentelo de nuevo",
              title: "Error",
              context: maincontext);
        } else if (l.message == "NO_REPORTS_FOUND") {
          PresentationDialogs.instance.showGenericDialog(
              content:
                  "Este producto no tiene movimientos en este tramo de tiempo",
              title: "Error",
              context: maincontext);
        } else {
          PresentationDialogs.instance.showGenericDialog(
              content:
                  "Ha habido un error al intentar cargar detalles, porfavor intentelo de nuevo, o vuelva a solicitar el informe, si el problema persiste contacte con el administrador",
              title: "Error",
              context: maincontext);
        }
      } else {
        PresentationDialogs.instance.showGenericDialog(
            content: "Error de conexion", title: "Error", context: maincontext);
      }
    }, (r) => null);
    setCreateProductReportState = CreateProductReportState.not_loadiing;
  }
}
