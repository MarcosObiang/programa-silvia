import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportEntity.dart';

class DepartmentReportMapper implements ToEntity<DepartmentReportEntity> {
  @override
  DepartmentReportEntity fromMap({required Map data}) {
    List<dynamic> reportDetailsParsed = [];
    List<dynamic> reportList = data["reportList"];
    Map readyData = Map();

    if (reportList.isEmpty) {
      throw GenericException(message: "NO_REPORTS_FOUND");
    }

    for (var report in reportList) {
      readyData = report;
      for (var reportDetail in report["reportDetails"]) {
        reportDetailsParsed.add(reportDetail);
      }
    }

    if (reportDetailsParsed.isEmpty) {
      throw GenericException(message: "NO_REPORTS_FOUND");
    } else {
      readyData.putIfAbsent("reportDetails", () => reportDetailsParsed);
      return DepartmentReportEntity.fromJson(readyData as Map<String, dynamic>);
    }
  }
}
