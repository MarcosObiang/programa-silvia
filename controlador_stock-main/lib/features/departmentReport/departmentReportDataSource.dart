import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:stockcontrollerterminal/Utils/services/ConnectionChecker/connectionChecker.dart';
import 'package:stockcontrollerterminal/Utils/services/ServerService/server.dart';

import '../../Utils/interfaces/errors/exceptions/Exceptions.dart';

abstract class DepartmentReportDataSource {
  Future<Map<String, dynamic>> getDepartmentReport(
      {required String departmentId,
      required DateTime fromDate,
      required DateTime toDate,
      required int offset});
  late Server server;
}

class DepartmentReportDataSourceImpl implements DepartmentReportDataSource {
  DepartmentReportDataSourceImpl({required this.server});

  @override
  Server server;

  @override
  Future<Map<String, dynamic>> getDepartmentReport(
      {required String departmentId,
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
              "reportType": "department",
              "offset": offset,
              "departmentId": departmentId,
              "fromDate": fromDate.toIso8601String(),
              "toDate": toDate.toIso8601String()
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
