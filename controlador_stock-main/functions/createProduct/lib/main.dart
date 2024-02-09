import 'dart:convert';

import 'package:dart_appwrite/dart_appwrite.dart';

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status: status)' - function to return text response. Status code defaults to 200
    'json(obj, status: status)' - function to return JSON response. Status code defaults to 200
  
  If an error is thrown, a response with code 500 will be returned.
*/

Future<void> start(final req, final res) async {
  try {
    Client client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('64526a7f32a8d0e4aaf4')
        .setKey(
            'f6ac6ea87ad81c3141ec04af485f33cf4f95051396eb018146951ac1e40ad6ef8d8f78ac60232947a653332d0faa1d045ca43261dd7ba8b082ed56c0ffcac1c1364bc25d5ee36e143945b474a8f015b833245081ce0ef9e035d000a4ff8e3e0946c1eabbac8db7ff45dac651f6102170df0407326002cb6a769d3599089e1219')
        .setSelfSigned(status: true);

    var data = jsonDecode(req.payload);
    Databases database = Databases(client);
    String productId = data["productId"];
    String productName = data["productName"];
    String productCount = data["productCount"];
    await database.createDocument(
        databaseId: "product_database",
        collectionId: "product_collection_id",
        documentId: productId,
        data: {
          "productId": productId,
          "productName": productName,
          "productCount": productCount,
          "product_withdrawals": 0,
          "product_entries": 0,
        },
        permissions: [
          Permission.read(Role.any())
        ]);

    return res.json({
      'status': 200,
      "message": "succesful",
    });
  } catch (e, s) {
    if (e is AppwriteException) {
      print({'status': "error", "mesage": e.message, "stackTrace": s});

      return res.json({
        'status': 500,
        "message": "ERROR",
      });
    } else {
      print({'status': "error", "mesage": e.toString(), "stackTrace": s});

      return res.json({
        'status': 200,
        "message": "succesful",
      });
    }
  }
}
