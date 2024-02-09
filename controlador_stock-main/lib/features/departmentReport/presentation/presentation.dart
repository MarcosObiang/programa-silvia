import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stockcontrollerterminal/Utils/dialogs/dialogs_file.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Presenter.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/presenter_should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportController.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/Widgets/Screen.dart';

enum CreateDepartmentReportState {
  loading,
  notLoading,
}

class DepartmentReportCreatorPresentationManager
    with ChangeNotifier
    implements
        PresenterLayer,
        VariablesDisposer,
        VariablesInitializer,
        PresenterShouldUpdate {
  DepartmentReportCreatorPresentationManager(
      {required this.departmentReportController});

  DepartmentReportController departmentReportController;
  CreateDepartmentReportState createDepartmentReportState =
      CreateDepartmentReportState.notLoading;

  set setCreateDepartmentReportState(
      CreateDepartmentReportState createDepartmentReportState) {
    this.createDepartmentReportState = createDepartmentReportState;
    notifyListeners();
  }

  @override
  late StreamSubscription<Map<String, dynamic>> presenterUpdateDataSubscription;

  @override
  ControllerState state = ControllerState.notLoaded;

  @override
  void disposeVariables() {
    departmentReportController.disposeVariables();
    presenterUpdateDataSubscription.cancel();
  }

  @override
  void initVariables() {
    departmentReportController.initVariables();
    presenterUpdate();
  }

  @override
  void presenterUpdate() {
    presenterUpdateDataSubscription =
        departmentReportController.updateController.stream.listen((event) {
      if (event["state"] is ControllerState) {
        state = event["state"];
      }
    });
  }

  void getMoreReports(
      {required String departmentId,
      required DateTime fromDate,
      required DateTime toDate}) async {
    var result = await departmentReportController.getMoreReports(
        departmentId: departmentId, fromDate: fromDate, toDate: toDate);

    result.fold((l) {
      if (l is NetworkException) {
        PresentationDialogs.instance
            .showNetworkErrorDialog(context: maincontext);
      } else {
        PresentationDialogs.instance.showErrorDialog(
            title: "Error",
            content: "Error al realizar la operacion",
            context: maincontext);
      }
    }, (r) => notifyListeners());
  }

  void getProductReport(
      {required String departmentId,
      required DateTime? fromDate,
      required DateTime? toDate}) async {
    setCreateDepartmentReportState = CreateDepartmentReportState.loading;

    var result = await departmentReportController.getDepartmentReport(
        departmentId: departmentId, fromDate: fromDate, toDate: toDate);
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
              content: "No se encontraron reportes",
              title: "Error",
              context: maincontext);
        } else {
          PresentationDialogs.instance.showGenericDialog(
              content: "Error al realizar la operacion ",
              title: "Error",
              context: maincontext);
        }
      }
      if (l is NetworkException) {
        PresentationDialogs.instance.showGenericDialog(
            content: "No hay conexion a internet",
            title: "Error",
            context: maincontext);
      }
    }, (r) => null);
    setCreateDepartmentReportState = CreateDepartmentReportState.notLoading;
  }
}
