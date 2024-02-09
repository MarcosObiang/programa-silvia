import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/real_time_parser.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/departments/departmentDataSource.dart';
import 'package:stockcontrollerterminal/features/departments/departmentEntity.dart';
import 'package:stockcontrollerterminal/features/productViewer/ProductEntity.dart';

abstract class DepartmentRepository
    implements
        VariablesDisposer,
        VariablesInitializer,
        RealTImeRepositoryParser {
  late DepartmentDataSource departmentDataSource;
  Future<Either<Exception, bool>> createDepartment(
      {required DepartmentEntity data});
  Future<Either<Exception, List<DepartmentEntity>>> getDepartments();
}

class DepartmentRepositoryImpl implements DepartmentRepository {
  DepartmentRepositoryImpl({required this.departmentDataSource});

  @override
  DepartmentDataSource departmentDataSource;

  @override
  StreamController<Map<String, dynamic>> realTimeRepositoryStreamController =
      StreamController();

  @override
  late StreamSubscription realTimeRepositoryStreamSubscription;

  @override
  Future<Either<Exception, bool>> createDepartment(
      {required DepartmentEntity data}) async {
    try {
      await departmentDataSource.createDeparment(
          data: data.toJson(instance: data));
      return const Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  void disposeVariables() {
    realTimeRepositoryStreamController.close();
    realTimeRepositoryStreamController = StreamController();
    realTimeRepositoryStreamSubscription.cancel();
  }

  @override
  Future<Either<Exception, List<DepartmentEntity>>> getDepartments() async {
    try {
      List<DepartmentEntity> departmentList = [];
      var data = await departmentDataSource.getDepartments();
      for (int i = 0; i < data.length; i++) {
        departmentList.add(DepartmentEntity.fromJson(json: data[i]));
      }
      return Right(departmentList);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  void initVariables() {
    repsitoryParser();
    departmentDataSource.initVariables();
  }

  @override
  void repsitoryParser() {
    realTimeRepositoryStreamSubscription = departmentDataSource
        .departmentsUpdateStreamController.stream
        .listen((event) {
      String eventType = event["eventType"];

      if (eventType == "addData") {
        var result = DepartmentEntity.fromJson(json: event["payload"]);

        realTimeRepositoryStreamController
            .add({"eventType": event["eventType"], "payload": result});
      } else {
        var result = DepartmentEntity.fromJson(json: event["payload"]);

        realTimeRepositoryStreamController
            .add({"eventType": event["eventType"], "payload": result});
      }
    });
  }
}
