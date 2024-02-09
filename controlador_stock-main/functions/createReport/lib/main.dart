import 'dart:async';
import 'dart:convert';
import 'package:dart_appwrite/dart_appwrite.dart';

// This is your Appwrite function
// It's executed each time we get a request
Future<dynamic> main(final context) async {
  try {
    Client client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('64526a7f32a8d0e4aaf4')
        .setKey(
            'f6ac6ea87ad81c3141ec04af485f33cf4f95051396eb018146951ac1e40ad6ef8d8f78ac60232947a653332d0faa1d045ca43261dd7ba8b082ed56c0ffcac1c1364bc25d5ee36e143945b474a8f015b833245081ce0ef9e035d000a4ff8e3e0946c1eabbac8db7ff45dac651f6102170df0407326002cb6a769d3599089e1219')
        .setSelfSigned(status: true);
    var data = jsonDecode(context.req.bodyRaw);

    String reportType = data["reportType"];
    Databases database = Databases(client);
    String? productId = data["productId"];
    String? departmentId = data["departmentId"];
    int offset = data["offset"];

    List<Map<String, dynamic>> reportList = [];

    if (reportType == "department") {
      String departmentId = data["departmentId"];
      DateTime fromDate = DateTime.parse(data["fromDate"]);
      DateTime toDate = DateTime.parse(data["toDate"]);

      var stockChanges = await database.listDocuments(
          databaseId: "product_database",
          collectionId: "stock_changes_id",
          queries: [
            Query.offset(offset),
            Query.equal("departmentId", departmentId),
            /* Query.between("changeDateTime", fromDate.toIso8601String(),
                toDate.toIso8601String())*/
          ]);
      List<Map<String, dynamic>> stockChangesData = [];
      for (int i = 0; i < stockChanges.documents.length; i++) {
        stockChangesData.add(stockChanges.documents[i].data);

        reportList.add({
          "reportDetails": stockChangesData,
          "fromDate": fromDate.toIso8601String(),
          "toDate": toDate.toIso8601String(),
          "reportType": "byDepartment",
          "departmentId": departmentId,
          "departmentName": stockChanges.documents[i].data["departments"]
              ["departmentName"]
        });
      }

      return context.res.json({
        "payload": {
          "reportList": reportList,
          "reportType": "byDepartment",
        },
        "status": 200
      });
    } else {
      if (productId != null) {
        DateTime fromDate = DateTime.parse(data["fromDate"]);
        DateTime toDate = DateTime.parse(data["toDate"]);
        var stockChanges = await database.listDocuments(
            databaseId: "product_database",
            collectionId: "stock_changes_id",
            queries: [
              Query.offset(offset),
              Query.equal("productId", productId),
              Query.greaterThanEqual(
                  "changeDateTime", fromDate.toUtc().toIso8601String()),
              Query.lessThanEqual(
                  "changeDateTime", toDate.toUtc().toIso8601String())
            ]);
        List<Map<String, dynamic>> stockChangesData = [];
        for (int i = 0; i < stockChanges.documents.length; i++) {
          stockChangesData.add(stockChanges.documents[i].data);
          reportList.add({
            "reportDetails": stockChangesData,
            "fromDate": fromDate.toIso8601String(),
            "toDate": toDate.toIso8601String(),
            "reportType": "byProduct",
            "productId": productId,
            "productName": stockChanges.documents[i].data["productName"]
          });
        }
      }

      return context.res.json({
        "payload": {
          "reportList": reportList,
          "reportType": "byProduct",
        },
        "status": 200
      });
    }
  } catch (e, s) {
    if (e is AppwriteException) {
      context.log({'status': "error", "mesage": e.message, "stackTrace": s});

      return context.res.json({
        'status': 500,
        "message": "ERROR",
      });
    } else {
      context.log({'status': "error", "mesage": e.toString(), "stackTrace": s});

      return context.res.json({
        'status': 500,
        "message": "ERROR",
      });
    }
  }
}
