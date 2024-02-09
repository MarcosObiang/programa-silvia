import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/departments/departmentEntity.dart';
import 'package:stockcontrollerterminal/features/departments/departmentRepository.dart';

abstract class DepartmentController
    implements
        ControllerLayer,
        VariablesDisposer,
        VariablesInitializer,
        ShouldUpdate {
  late DepartmentRepository departmentRepository;
  Future<Either<Exception, List<DepartmentEntity>>> getDepartments();
  Future<Either<Exception, bool>> createDepartment(
      {required DepartmentEntity data});
  late List<DepartmentEntity> departmentList;
  late List<Map<String, dynamic>> suggestionsList = [];

  void selectDepartment({required String departmentId});
  void selectAllDepartments();
  void unselectAllDepartments();
  void unselectDepartment({required String departmentId});
  void searchSuggestions({required String input});
}

class DepartmentControllerImpl implements DepartmentController {
  DepartmentControllerImpl({required this.departmentRepository});

  @override
  List<Map<String, dynamic>> suggestionsList = [];

  @override
  List<DepartmentEntity> departmentList = [];

  @override
  DepartmentRepository departmentRepository;

  @override
  ControllerState state = ControllerState.notLoaded;

  @override
  StreamController<Map<String, dynamic>> updateController = StreamController();

  late StreamSubscription streamSubscription;

  @override
  Future<Either<Exception, bool>> createDepartment(
      {required DepartmentEntity data}) async {
    var result = await departmentRepository.createDepartment(data: data);

    sendUpdateData();
    return result;
  }

  @override
  void disposeVariables() {
    departmentList = List.empty(growable: true);
    state = ControllerState.notLoaded;
    if (updateController.isClosed == false) {
      updateController.close();
    }
    streamSubscription.cancel();
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getDepartments() async {
    var result = await departmentRepository.getDepartments();
    result.fold((l) => null, (r) => departmentList.addAll(r));

    sendUpdateData();
    return result;
  }

  @override
  void initVariables() {
    getDepartments();
    _repositoryListener();
    departmentRepository.initVariables();
  }

  @override
  void sendUpdateData() {
    updateController.add({"event": "update", "state": state});
  }

  void _repositoryListener() {
    streamSubscription = departmentRepository
        .realTimeRepositoryStreamController.stream
        .listen((event) {
      String eventType = event["eventType"];
      DepartmentEntity departmentEntity = event["payload"];
      if (eventType == "addData") {
        departmentList.add(departmentEntity);
        updateController.add({"event": "update", "state": state});
      }
      if (eventType == "removeData") {
        updateController.add({"event": "update", "state": state});
        for (int i = 0; i < departmentList.length; i++) {
          if (departmentList[i].departmentId == departmentEntity.departmentId) {
            int whereToRemove = departmentList.indexWhere((element) =>
                element.departmentId == departmentEntity.departmentId);

            departmentList.removeAt(whereToRemove);
            break;
          }
        }
      }
      if (eventType == "updateData") {
        for (int i = 0; i < departmentList.length; i++) {
          if (departmentList[i].departmentId == departmentEntity.departmentId) {
            departmentList[i] = departmentEntity;
            break;
          }
        }
      }
      sendUpdateData();
    });
  }

  @override
  void selectAllDepartments() {
    for (int i = 0; i < departmentList.length; i++) {
      departmentList[i].isDepartmenSelectedInTable = true;
    }
    sendUpdateData();
  }

  @override
  void selectDepartment({required String departmentId}) {
    for (int i = 0; i < departmentList.length; i++) {
      if (departmentList[i].departmentId == departmentId) {
        departmentList[i].isDepartmenSelectedInTable = true;
        break;
      }
    }
    sendUpdateData();
  }

  @override
  void unselectDepartment({required String departmentId}) {
    for (int i = 0; i < departmentList.length; i++) {
      if (departmentList[i].departmentId == departmentId) {
        departmentList[i].isDepartmenSelectedInTable = false;
        break;
      }
    }
    sendUpdateData();
  }

  @override
  void unselectAllDepartments() {
    for (int i = 0; i < departmentList.length; i++) {
      departmentList[i].isDepartmenSelectedInTable = false;
    }
    sendUpdateData();
  }

  @override
  void searchSuggestions({required String input}) {
    suggestionsList.clear();
    List<Map<String, dynamic>> dataList = [];
    for (int i = 0; i < departmentList.length; i++) {
      if (departmentList[i]
          .departmentName
          .toLowerCase()
          .contains(input.toLowerCase())) {
        dataList.add({
          "departmentName": departmentList[i].departmentName,
          "departmentId": departmentList[i].departmentId
        });
      }
    }
    suggestionsList.addAll(dataList);
    sendUpdateData();
  }
}
