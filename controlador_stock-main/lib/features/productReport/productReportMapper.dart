import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/features/productReport/productRepoEntity.dart';
import 'package:stockcontrollerterminal/features/productReport/reportDetailsEntity.dart';

class ProductReportMapper implements ToEntity<ProductReportEntity> {
  @override
  ProductReportEntity fromMap({required Map data}) {
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

    readyData.putIfAbsent("reportDetails", () => reportDetailsParsed);

    return ProductReportEntity.fromMap(readyData as Map<String, dynamic>);
  }
}
