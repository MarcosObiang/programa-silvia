import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/Utils/services/ConnectionChecker/connectionChecker.dart';
import 'package:stockcontrollerterminal/Utils/services/ServerService/server.dart';

abstract class StockChangerDataSource
    implements VariablesDisposer, VariablesInitializer {
  late StreamController<Map<String, dynamic>> productsUpdateStreamController;

  void listenToProducts();

  late Server server;
  Future<bool> updateStock({required Map<String, dynamic> data});
  Future<List<Map<String, dynamic>>> getProducts();
}

class StockChangerDataSourceImpl implements StockChangerDataSource {
  StockChangerDataSourceImpl({
    required this.server,
  });

  late StreamSubscription streamSubscription;
  @override
  StreamController<Map<String, dynamic>> productsUpdateStreamController =
      StreamController();

  @override
  Server server;
  @override
  void initVariables() {
    listenToProducts();
  }

  @override
  void disposeVariables() {
    productsUpdateStreamController = StreamController();
    productsUpdateStreamController.close();
    streamSubscription.cancel();
  }

  @override
  Future<bool> updateStock({required Map<String, dynamic> data}) async {
    if (await ConnectionChecker.checkConnection() == false) {
      throw NetworkException(message: "No internet connection");
    } else {
      try {
        Functions functions = Functions(server.client!);
        final execution = await functions.createExecution(
            functionId: "createNewProductWithdrawal", body: jsonEncode(data));
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

  @override
  void listenToProducts() {
    String databaseReference =
        "databases.product_database.collections.product_collection_id.documents";
    Realtime realtime = Realtime(server.client!);

    streamSubscription =
        realtime.subscribe([databaseReference]).stream.listen((event) {
              String createEvent =
                  "$databaseReference.${event.payload["productId"]}.create";
              String updateEvent =
                  "$databaseReference.${event.payload["productId"]}.update";
              String deleteEvent =
                  "$databaseReference.${event.payload["productId"]}.delete";

              if (event.events.first.contains(createEvent)) {
                _sendAddDataEvent(productData: event.payload);
              }
              if (event.events.first.contains(updateEvent)) {
                _sendUpdateDataEvent(productData: event.payload);
              }
              if (event.events.first.contains(deleteEvent)) {
                _sendRemoveDataEvent(productData: event.payload);
              }
            });
  }

  @override
  Future<List<Map<String, dynamic>>> getProducts() async {
    if (await ConnectionChecker.checkConnection() == false) {
      throw NetworkException(message: "No internet connection");
    } else {
      try {
        List<Map<String, dynamic>> data = [];
        Databases databases = Databases(server.client!);
        var documentData = await databases.listDocuments(
            databaseId: "product_database",
            collectionId: "product_collection_id");

        for (int i = 0; i < documentData.documents.length; i++) {
          data.add(documentData.documents[i].data);
        }

        return data;
      } catch (e) {
        throw GenericException(message: e.toString());
      }
    }
  }

  void _sendAddDataEvent({required Map<String, dynamic> productData}) {
    productsUpdateStreamController
        .add({"eventType": "addData", "payload": productData});
  }

  void _sendRemoveDataEvent({required Map<String, dynamic> productData}) {
    productsUpdateStreamController
        .add({"eventType": "removeData", "payload": productData});
  }

  void _sendUpdateDataEvent({required Map<String, dynamic> productData}) {
    productsUpdateStreamController
        .add({"eventType": "updateData", "payload": productData});
  }
}
