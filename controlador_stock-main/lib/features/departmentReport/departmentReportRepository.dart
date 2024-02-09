import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportDataSource.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportEntity.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportMapper.dart';
import 'package:stockcontrollerterminal/features/productReport/productRepoEntity.dart';

abstract class DepartmetntReportRepository {
  late DepartmentReportDataSource departmentReportDataSource;
  Future<Either<Exception, DepartmentReportEntity>> getReport(
      {required String departmentId,
      required DateTime? fromDate,
      required DateTime? toDate,
      required int offset});
  late DepartmentReportMapper departmentReportMapper;
}

class DepartmentReportRepositoryImpl implements DepartmetntReportRepository {
  @override
  DepartmentReportDataSource departmentReportDataSource;
  @override
  DepartmentReportMapper departmentReportMapper;
  DepartmentReportRepositoryImpl(
      {required this.departmentReportDataSource,
      required this.departmentReportMapper});

  @override
  Future<Either<Exception, DepartmentReportEntity>> getReport(
      {required String departmentId,
      required DateTime? fromDate,
      required DateTime? toDate,
      required int offset}) async {
    try {
      var data = await departmentReportDataSource.getDepartmentReport(
          departmentId: departmentId,
          fromDate: fromDate as DateTime,
          toDate: toDate as DateTime,
          offset: offset);
      DepartmentReportEntity departmetnReportEntity =
          departmentReportMapper.fromMap(data: data);

      return Right(departmetnReportEntity);
    } on Exception catch (_) {
      return Left(_);
    }
  }
}
