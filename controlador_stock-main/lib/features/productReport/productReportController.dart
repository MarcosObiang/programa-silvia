import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/productReport/productRepoEntity.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportRepo.dart';
import 'package:stockcontrollerterminal/features/productReport/reportDetailsEntity.dart';

abstract class ProductReportController
    implements
        ControllerLayer,
        VariablesDisposer,
        VariablesInitializer,
        ShouldUpdate {
  late ProductReportRepo productReportRepo;
  late List<ProductReportEntity> reportList;
  Future<Either<Exception, ProductReportEntity>> getProductReprot(
      {required String productId,
      required DateTime? fromDate,
      required DateTime? toDate});

  Future<Either<Exception, List<ReportDetailsEntity>>> getMoreReports(
      {required String productId,
      required DateTime fromDate,
      required DateTime toDate});

  void clearReportMemory();
}

class ProductReportControllerImpl implements ProductReportController {
  ProductReportControllerImpl({required this.productReportRepo});

  @override
  ProductReportRepo productReportRepo;

  @override
  List<ProductReportEntity> reportList = [];

  @override
  ControllerState state = ControllerState.notLoaded;

  @override
  StreamController<Map<String, dynamic>> updateController = StreamController();

  @override
  void disposeVariables() {
    updateController.close();
    updateController = StreamController();
    reportList.clear();
    state = ControllerState.notLoaded;
  }

  @override
  Future<Either<Exception, ProductReportEntity>> getProductReprot(
      {required String productId,
      required DateTime? fromDate,
      required DateTime? toDate}) async {
    bool reportExists = false;
    var result = await productReportRepo.getReport(
        productId: productId, fromDate: fromDate, toDate: toDate, offset: 0);
    result.fold((l) => null, (r) {
      if (checkIfreportExists(productReportEntity: r) == false) {
        reportList.add(r);
      } else {
        reportExists = true;
      }
    });

    return reportExists
        ? Left(
            GenericException(message: "THIS_REPORT_ALREADY_EXISTS_IN_MEMORY"))
        : result;
  }

  bool checkIfreportExists({required ProductReportEntity productReportEntity}) {
    bool exists = false;

    for (int i = 0; i < reportList.length; i++) {
      if (reportList[i].productId != null &&
          productReportEntity.productId != null) {
        if (reportList[i].fromDate != null &&
            productReportEntity.fromDate != null) {
          if (reportList[i].fromDate != null &&
              productReportEntity.fromDate != null) {
            if ((reportList[i]
                            .fromDate!
                            .difference(productReportEntity.fromDate!))
                        .inSeconds ==
                    0 &&
                (reportList[i].toDate!.difference(productReportEntity.toDate!))
                        .inSeconds ==
                    0) {
              exists = true;
              break;
            }
          }
        }
      }
    }
    return exists;
  }

  @override
  void clearReportMemory() {
    reportList.clear();
  }

  @override
  void initVariables() {
    // TODO: implement initVariables
  }

  @override
  void sendUpdateData() {
    // TODO: implement sendUpdateData
  }

  @override
  Future<Either<Exception, List<ReportDetailsEntity>>> getMoreReports(
      {required String productId,
      required DateTime fromDate,
      required DateTime toDate}) async {
    int reportDetailsOffset = 0;
    int productIndex = 0;
    List<ReportDetailsEntity> detailsList = List.empty(growable: true);
    if (reportList.isNotEmpty) {
      productIndex = reportList.indexWhere((element) =>
          ((element.productId == productId) &&
              (element.fromDate == fromDate) &&
              (element.toDate == toDate)));

      if (productIndex != -1) {
        reportDetailsOffset = reportList[productIndex].reportDetails!.length;
        var result = await productReportRepo.getReport(
            productId: productId,
            fromDate: fromDate,
            toDate: toDate,
            offset: reportDetailsOffset);
        result.fold((l) => null, (r) {
          if (r.reportDetails!.isNotEmpty) {
            detailsList.addAll(r.reportDetails!);
            reportList[productIndex].reportDetails!.addAll(detailsList);
          }
        });

        if (detailsList.isNotEmpty) {
          return Right(detailsList);
        } else {
          return Left(GenericException(message: "NO_REPORTS_FOUND"));
        }
      } else {
        return Left(GenericException(
            message: "THE_REPORT_YOU_ARE_TRYING_TO_GET_IS_NOT_IN_MEMORY"));
      }
    } else {
      return Left(GenericException(
          message: "THE_REPORT_YOU_ARE_TRYING_TO_GET_IS_NOT_IN_MEMORY"));
    }
  }
}
