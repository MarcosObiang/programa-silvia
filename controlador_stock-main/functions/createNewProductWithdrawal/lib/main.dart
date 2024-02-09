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
    Databases database = Databases(client);

    String changedBy = data["changedBy"];
    List<dynamic> stockChanges = data["stockUpdate"];
    String departmentId = data["departmentId"];

    for (dynamic updateData in stockChanges) {
      String productId = updateData["productId"];
      int amountToChange = updateData["amountToChange"];
      String changeType = updateData["changeType"];

      var productDetails = await database.getDocument(
          databaseId: "product_database",
          collectionId: "product_collection_id",
          documentId: productId);

      int productCount = productDetails.data["productCount"];

      String productName = productDetails.data["productName"];

      if (changeType == "RETIRE") {
        int productsOut = productDetails.data["productsOut"];
        String date = DateTime.now().toIso8601String();
        if (productCount < productCount) {
          return context.res.json({
            "status": 200,
            "message": "CANNOT_WITHDRAW_MORE_PRODUCTS_THAN_AVAILABLE"
          });
        } else {
          int newProductCount = productCount - amountToChange;

          await database.updateDocument(
              databaseId: "product_database",
              collectionId: "product_collection_id",
              documentId: productId,
              data: {
                "productCount": newProductCount,
                "productsOut": productsOut - amountToChange
              });
          await database.createDocument(
              databaseId: "product_database",
              collectionId: "stock_changes_id",
              documentId: ID.unique(),
              data: {
                "productCountAfterChange": newProductCount,
                "productCountBeforeChange": productCount,
                "changedBy": changedBy,
                "changeDateTime": date,
                "productId": productId,
                "productName": productName,
                "changeType": "WITHDRAWL_PRODUCT",
                "departmentId": departmentId,
                "departments": departmentId
              });
          var departmentDetails = await database.getDocument(
              databaseId: "product_database",
              collectionId: "departments_collection",
              documentId: departmentId);

          int productWithdrawlCount =
              departmentDetails.data["productWithdrawlCount"] ?? 0;
          await database.updateDocument(
              databaseId: "product_database",
              collectionId: "departments_collection",
              documentId: departmentId,
              data: {
                "productWithdrawlCount": productWithdrawlCount + 1,
              });
        }
      } else {
        int newProductCount = productCount + amountToChange;
        int productsIn = productDetails.data["productsIn"];

        String date = DateTime.now().toIso8601String();

        await database.updateDocument(
            databaseId: "product_database",
            collectionId: "product_collection_id",
            documentId: productId,
            data: {
              "productCount": newProductCount,
              "productsIn": amountToChange + productsIn
            });

        await database.createDocument(
            databaseId: "product_database",
            collectionId: "stock_changes_id",
            documentId: ID.unique(),
            data: {
              "productCountAfterChange": newProductCount,
              "productCountBeforeChange": productCount,
              "changedBy": changedBy,
              "changeDateTime": date,
              "productId": productId,
              "productName": productName,
              "changeType": "ADD_PRODUCT",
              "departmentId": departmentId,
              "departments": departmentId
            });
        var departmentDetails = await database.getDocument(
            databaseId: "product_database",
            collectionId: "departments_collection",
            documentId: departmentId);

        int productAddCount = departmentDetails.data["productAddCount"] ?? 0;
        await database.updateDocument(
            databaseId: "product_database",
            collectionId: "departments_collection",
            documentId: departmentId,
            data: {
              "productAddCount": productAddCount + 1,
            });
      }
    }

    return context.res.json({
      'status': 200,
      "message": "succesful",
    });
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
