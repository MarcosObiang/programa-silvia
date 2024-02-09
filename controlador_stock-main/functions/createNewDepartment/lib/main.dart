import 'dart:async';
import 'dart:math';

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
    context.log(context.req.bodyRaw);
    String departmentName = data["departmentName"];
    String creationDate = DateTime.now().toIso8601String();
    Databases database = Databases(client);
    String departmentId = IdGenerator.instancia.createId();

    await database.createDocument(
        databaseId: "product_database",
        collectionId: "departments_collection",
        documentId: departmentId,
        data: {
          "departmentName": departmentName,
          "departmentId": departmentId,
          "departmentCreationDate": creationDate
        });

    return context.res.json({"status": "succes"});
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

class IdGenerator {
  static IdGenerator instancia = IdGenerator();

  String createId() {
    List<String> letras = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ];
    List<String> numero = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
    var random = Random();
    int primeraLetra = random.nextInt(26);
    String finalCode = letras[primeraLetra];

    for (int i = 0; i <= 10; i++) {
      int characterTypeIndicator = random.nextInt(20);
      int randomWord = random.nextInt(27);
      int randomNumber = random.nextInt(9);
      if (characterTypeIndicator <= 2) {
        characterTypeIndicator = 2;
      }
      if (characterTypeIndicator % 2 == 0) {
        finalCode = "$finalCode${(numero[randomNumber])}";
      }
      if (randomWord % 3 == 0) {
        int mayuscula = random.nextInt(9);
        if (characterTypeIndicator <= 2) {
          int suerte = random.nextInt(2);
          suerte == 0 ? characterTypeIndicator = 3 : characterTypeIndicator = 2;
        }
        if (mayuscula % 2 == 0) {
          finalCode = "$finalCode${(letras[randomWord]).toUpperCase()}";
        }
        if (mayuscula % 3 == 0) {
          finalCode = "$finalCode${(letras[randomWord]).toLowerCase()}";
        }
      }
    }
    return finalCode;
  }
}
