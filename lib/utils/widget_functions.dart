import 'package:flutter/material.dart';

showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  String positiveButtonText = 'OK',
  String negativeButtonText = 'CLOSE',
  required Function(String) onSubmit,
}) {
  final txtController = TextEditingController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: txtController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter $title',
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(negativeButtonText),
              ),
              TextButton(
                onPressed: () {
                  if (txtController.text.isEmpty) return;
                  final value = txtController.text;
                  Navigator.pop(context);
                  onSubmit(value);
                },
                child: Text(positiveButtonText),
              )
            ],
          ));
}

redirectingDialog(
    {required BuildContext context,
    required String source,
    required String destination,
    required String title,
    required String msg}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, destination, arguments: source);
          },
          child: const Text('Ok'),
        )
      ],
    ),
  );
}
