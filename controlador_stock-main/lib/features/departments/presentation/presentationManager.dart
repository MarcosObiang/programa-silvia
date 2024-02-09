import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stockcontrollerterminal/Utils/dialogs/dialogs_file.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Presenter.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/departments/departmentController.dart';
import 'package:stockcontrollerterminal/features/departments/departmentEntity.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/Widgets/Screen.dart';

import '../../../Utils/interfaces/presenter_should_update.dart';
import '../../../Utils/interfaces/variables_disposer.dart';
import '../../../Utils/interfaces/variables_initializer.dart';

enum CreateDepartmentProcessState {
  LOADING,
  NOT_LOADING,
}

class DepartmentPresentationManager
    with ChangeNotifier
    implements
        PresenterLayer,
        VariablesDisposer,
        VariablesInitializer,
        PresenterShouldUpdate {
  DepartmentController departmentController;
  CreateDepartmentProcessState createDepartmentProcessState =
      CreateDepartmentProcessState.NOT_LOADING;
  DepartmentPresentationManager({required this.departmentController});

  @override
  late StreamSubscription<Map<String, dynamic>> presenterUpdateDataSubscription;

  @override
  ControllerState state = ControllerState.notLoaded;

  set setControllerState(ControllerState newState) {
    state = newState;
    notifyListeners();
  }

  set setCreateDepartmentProcessState(
      CreateDepartmentProcessState createProductProcessState) {
    createDepartmentProcessState = createProductProcessState;
    notifyListeners();
  }

  @override
  void disposeVariables() {
    departmentController.disposeVariables();
    setControllerState = ControllerState.notLoaded;
    presenterUpdateDataSubscription.cancel();
  }

  @override
  void initVariables() {
    departmentController.initVariables();
    presenterUpdate();
  }

  @override
  void presenterUpdate() {
    presenterUpdateDataSubscription =
        departmentController.updateController.stream.listen((event) {
      notifyListeners();
    });
  }

  void createDepartment({required DepartmentEntity departmentEntity}) async {
    setCreateDepartmentProcessState = CreateDepartmentProcessState.LOADING;
    var result =
        await departmentController.createDepartment(data: departmentEntity);

    setCreateDepartmentProcessState = CreateDepartmentProcessState.NOT_LOADING;

    result.fold((l) {
      if (l is GenericException) {
        PresentationDialogs.instance.showGenericDialog(
            content: "Error al realizar la operacion ",
            title: "Error",
            context: maincontext);
      } else {
        PresentationDialogs.instance.showGenericDialog(
            content: "No se ha podido conectar con el servidor",
            title: "Error",
            context: maincontext);
      }
    },
        (r) => PresentationDialogs.instance.showGenericDialog(
            content: "El departamento se ha creado correctamente",
            title: "Nuevo departmaneto",
            context: maincontext));
  }
}
