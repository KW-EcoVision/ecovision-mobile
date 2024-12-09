import 'package:flutter/cupertino.dart';

class EcoAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final void Function()? acceptFunction;
  final void Function()? cancelFunction;
  const EcoAlertDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.acceptFunction,
      required this.cancelFunction});

  @override
  State<EcoAlertDialog> createState() => _EcoAlertDialogState();
}

class _EcoAlertDialogState extends State<EcoAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: widget.acceptFunction,
          child: const Text("확인"),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: widget.cancelFunction,
          child: const Text("취소"),
        )
      ],
    );
  }
}
