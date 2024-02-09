import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/Utils/services/ConnectionChecker/connectionChecker.dart';
import 'package:stockcontrollerterminal/Utils/services/ServerService/server.dart';

abstract class DepartmentDataSource
    implements VariablesDisposer, VariablesInitializer {
  late StreamController<Map<String, dynamic>> departmentsUpdateStreamController;
  Future<bool> createDeparment({required Map<String, dynamic> data});
  Future<List<Map<String, dynamic>>> getDepartments();
  void listenToDeparments();
  late Server server;
}

class DepartmentDataSourceImpl implements DepartmentDataSource {
  DepartmentDataSourceImpl({
    required this.server,
  });

  late StreamSubscription streamSubscription;

  @override
  StreamController<Map<String, dynamic>> departmentsUpdateStreamController =
      StreamController();

  @override
  Server server;

  @override
  Future<bool> createDeparment({required Map<String, dynamic> data}) async {
    if (await ConnectionChecker.checkConnection() == false) {
      throw NetworkException(message: "No internet connection");
    } else {
      try {
        if (data["departmentName"] == null || data["departmentName"] == "") {
          throw GenericException(message: "Department name cannot be empty");
        }

        Functions functions = Functions(server.client!);
        final execution = await functions.createExecution(
            functionId: "createNewDepartment", body: jsonEncode(data));
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
  void disposeVariables() {
    departmentsUpdateStreamController = StreamController();
    departmentsUpdateStreamController.close();
    streamSubscription.cancel();
  }

  @override
  void initVariables() {
    listenToDeparments();
  }

  @override
  Future<List<Map<String, dynamic>>> getDepartments() async {
    try {
      List<Map<String, dynamic>> data = [];
      Databases databases = Databases(server.client!);
      var documentData = await databases.listDocuments(
          databaseId: "product_database",
          collectionId: "departments_collection");

      for (int i = 0; i < documentData.documents.length; i++) {
        data.add(documentData.documents[i].data);
      }

      return data;
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }

  @override
  void listenToDeparments() {
    String databaseReference =
        "databases.product_database.collections.departments_collection.documents";
    Realtime realtime = Realtime(server.client!);

    streamSubscription =
        realtime.subscribe([databaseReference]).stream.listen((event) {
              String createEvent =
                  "$databaseReference.${event.payload["departmentId"]}.create";
              String updateEvent =
                  "$databaseReference.${event.payload["departmentId"]}.update";
              String deleteEvent =
                  "$databaseReference.${event.payload["departmentId"]}.delete";

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

  void _sendAddDataEvent({required Map<String, dynamic> productData}) {
    departmentsUpdateStreamController
        .add({"eventType": "addData", "payload": productData});
  }

  void _sendRemoveDataEvent({required Map<String, dynamic> productData}) {
    departmentsUpdateStreamController
        .add({"eventType": "removeData", "payload": productData});
  }

  void _sendUpdateDataEvent({required Map<String, dynamic> productData}) {
    departmentsUpdateStreamController
        .add({"eventType": "updateData", "payload": productData});
  }
}
