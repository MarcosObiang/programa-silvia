import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportDetailsEntity.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportEntity.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportRepository.dart';
import 'package:stockcontrollerterminal/features/departments/departmentEntity.dart';

abstract class DepartmentReportController
    implements
        ControllerLayer,
        VariablesDisposer,
        VariablesInitializer,
        ShouldUpdate {
  late DepartmetntReportRepository departmentReportRepository;
  late List<DepartmentReportEntity> departmentReports;
  Future<Either<Exception, List<DepartmentReportDetailsEntity>>> getMoreReports(
      {required String departmentId,
      required DateTime fromDate,
      required DateTime toDate});

  Future<Either<Exception, DepartmentReportEntity>> getDepartmentReport(
      {required String departmentId,
      required DateTime? fromDate,
      required DateTime? toDate});
  void clearReportMemory();
}

class DepartmentReportControllerImpl implements DepartmentReportController {
  DepartmentReportControllerImpl({required this.departmentReportRepository});

  @override
  DepartmetntReportRepository departmentReportRepository;

  @override
  List<DepartmentReportEntity> departmentReports = [];

  @override
  ControllerState state = ControllerState.notLoaded;

  @override
  StreamController<Map<String, dynamic>> updateController = StreamController();

  @override
  void clearReportMemory() {
    departmentReports.clear();
  }

  @override
  void disposeVariables() {
    // TODO: implement disposeVariables
  }
  @override
  Future<Either<Exception, List<DepartmentReportDetailsEntity>>> getMoreReports(
      {required String departmentId,
      required DateTime fromDate,
      required DateTime toDate}) async {
    int reportDetailsOffset = 0;
    int departmentIndex = 0;

    List<DepartmentReportDetailsEntity> detailsList =
        List.empty(growable: true);
    if (departmentReports.isNotEmpty) {
      departmentIndex = departmentReports.indexWhere((element) =>
          ((element.departmentId == departmentId) &&
              (element.fromDate == fromDate) &&
              (element.toDate == toDate)));
      if (departmentIndex != -1) {
        reportDetailsOffset =
            departmentReports[departmentIndex].reportDetails.length;
        var result = await departmentReportRepository.getReport(
            departmentId: departmentId,
            fromDate: departmentReports[departmentIndex].fromDate,
            toDate: departmentReports[departmentIndex].toDate,
            offset: reportDetailsOffset);

        result.fold((l) => null, (r) {
          if (r.reportDetails.isNotEmpty) {
            detailsList.addAll(r.reportDetails);
            departmentReports[departmentIndex]
                .reportDetails
                .addAll(detailsList);
          }
        });
      }
      if (detailsList.isNotEmpty) {
        return Right(detailsList);
      } else {
        return Left(Exception("NO_MORE_REPORTS"));
      }
    } else {
      return Left(
          Exception("THE_REPORT_YOU_ARE_TRYING_TO_GET_IS_NOT_IN_MEMORY"));
    }
  }

  @override
  Future<Either<Exception, DepartmentReportEntity>> getDepartmentReport(
      {required String departmentId,
      required DateTime? fromDate,
      required DateTime? toDate}) async {
    bool reportExists = false;

    /* int offset = departmentReports
        .firstWhere((element) => element.departmentId == departmentId)
        .reportDetails
        .length;*/

    var result = await departmentReportRepository.getReport(
        departmentId: departmentId,
        fromDate: fromDate,
        toDate: toDate,
        offset: 0);
    result.fold((l) => null, (r) {
      if (checkIfDepartmentReportExists(r) == false) {
        departmentReports.add(r);
      } else {
        reportExists = true;
      }
    });
    return reportExists
        ? Left(
            GenericException(message: "THIS_REPORT_ALREADY_EXISTS_IN_MEMORY"))
        : result;
  }

  bool checkIfDepartmentReportExists(
      DepartmentReportEntity departmentReportEntity) {
    bool exists = false;
    for (int i = 0; i < departmentReports.length; i++) {
      if ((departmentReports[i]
                      .fromDate
                      .difference(departmentReportEntity.fromDate))
                  .inSeconds ==
              0 &&
          (departmentReports[i]
                      .toDate
                      .difference(departmentReportEntity.toDate))
                  .inSeconds ==
              0) {
        exists = true;
        break;
      }
    }
    return exists;
  }

  @override
  void initVariables() {
    // TODO: implement initVariables
  }

  @override
  void sendUpdateData() {
    // TODO: implement sendUpdateData
  }
}
