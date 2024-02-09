import 'package:flutter/material.dart';

class PresentationDialogs {
  static PresentationDialogs instance = PresentationDialogs();

  void showErrorDialog(
      {required String title,
      required String content,
      required BuildContext? context}) {
    if (context != null) {
      showDialog(
          context: context,
          builder: (context) =>
              GenericErrorDialog(title: title, content: content));
    }
  }

  void showGenericDialog(
      {required String title,
      required String content,
      required BuildContext? context}) {
    if (context != null) {
      showDialog(
          context: context,
          builder: (context) => GenericDialog(title: title, content: content));
    }
  }

  void showNetworkErrorDialog({required BuildContext? context}) {
    if (context != null) {
      showDialog(context: context, builder: (context) => NetwortErrorWidget());
    }
  }

  void showLoadingDialog({required BuildContext? context}) {}

  void showErrorDialogWithOptions(
      {required BuildContext? context,
      required List<DialogOptions> dialogOptionsList,
      required String dialogTitle,
      required String dialogText}) {
    List<Widget> buttons = [];

    for (var element in dialogOptionsList) {
      buttons.add(TextButton(
        child: Text(element.text),
        onPressed: () => element.function.call(),
      ));
    }

    if (context != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(dialogTitle),
                content: Text(dialogText),
                actions: buttons,
              ));
    }
  }
}

class DialogOptions {
  /// The functions that will be called after pressing the button
  VoidCallback function;

  /// The visible name of the button
  String text;
  DialogOptions({
    required this.function,
    required this.text,
  });
}

class NetwortErrorWidget extends StatelessWidget {
  const NetwortErrorWidget();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text("No se ha detectado una conexion a internet"),
      title: const Text("No hay conexion"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"))
      ],
    );
  }
}

class GenericErrorDialog extends StatelessWidget {
  final String content;
  final String title;

  const GenericErrorDialog({required this.content, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      title: Text(title),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Entendido"))
      ],
    );
  }
}

class GenericDialog extends StatelessWidget {
  final String content;
  final String title;

  const GenericDialog({required this.content, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      title: Text(title),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Entendido"))
      ],
    );
  }
}
