import 'package:appwrite/appwrite.dart';

class Server {
  Client? client;
  Account? account;
  Server() {
    initializeServer();
  }

  void initializeServer() async {
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite Endpoint
        .setProject('64526a7f32a8d0e4aaf4') // Your project ID
        .setSelfSigned(status: true);
    account = Account(client!);
  }
}
