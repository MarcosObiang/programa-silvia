import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/services/ConnectionChecker/connectionChecker.dart';
import 'package:stockcontrollerterminal/Utils/services/ServerService/server.dart';

abstract class ProductReportDataSource {
  Future<Map<String, dynamic>> getProductsReport(
      {required String productId,
      required DateTime fromDate,
      required DateTime toDate,
      required int offset});
  late Server server;
}

class ProductReportDataSourceImpl implements ProductReportDataSource {
  ProductReportDataSourceImpl({required this.server});

  @override
  Server server;

  @override
  Future<Map<String, dynamic>> getProductsReport(
      {required String productId,
      required DateTime fromDate,
      required DateTime toDate,
      required int offset}) async {
    if (await ConnectionChecker.checkConnection() == false) {
      throw NetworkException(message: "No internet connection");
    } else {
      try {
        Functions functions = Functions(server.client!);
        final execution = await functions.createExecution(
            functionId: "createReport",
            body: jsonEncode({
              "reportType": "product",
              "productId": productId,
              "fromDate": fromDate.toIso8601String(),
              "toDate": toDate.toIso8601String(),
              "offset": offset
            }));
        if (execution.responseStatusCode == 200) {
          return jsonDecode(execution.responseBody)["payload"];
        } else {
          throw GenericException(message: execution.responseBody);
        }
      } catch (e) {
        throw GenericException(message: e.toString());
      }
    }
  }
}
