import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/services/ConnectionChecker/connectionChecker.dart';
import 'package:stockcontrollerterminal/Utils/services/ServerService/server.dart';

abstract class ProductCreatorDataSource {
  late Server server;
  Future<bool> createProdcut({required Map<String, dynamic> data});
}

class ProductCreatorDataSourceImpl implements ProductCreatorDataSource {
  @override
  Server server;
  ProductCreatorDataSourceImpl({required this.server});

  @override
  Future<bool> createProdcut({required Map<String, dynamic> data}) async {
    if (await ConnectionChecker.checkConnection() == false) {
      throw NetworkException(message: "No internet connection");
    } else {
      try {
        Functions functions = Functions(server.client!);
        final execution = await functions.createExecution(
            functionId: "createNewProduct", body: jsonEncode(data));
        if (execution.responseStatusCode == 200) {
          return true;
        } else {
          throw GenericException(message: execution.responseBody);
        }
      } catch (e) {
        throw GenericException(message: e.toString());
      }
    }
  }
}
