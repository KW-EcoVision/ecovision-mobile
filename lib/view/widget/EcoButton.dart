import 'package:flutter/material.dart';

class EcoButton extends StatefulWidget {
  final void Function()? onPressed;
  final String text;
  final double radius;
  final double? width;
  final double? height;
  final Color backgroundColor;

  const EcoButton(
      {required this.onPressed,
      required this.text,
      required this.radius,
      this.width,
      this.height,
      required this.backgroundColor,
      super.key});

  @override
  State<EcoButton> createState() => _EcoButtonState();
}

class _EcoButtonState extends State<EcoButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          overlayColor: WidgetStateColor.resolveWith((states) => Colors.white),
          backgroundColor: widget.backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius))),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
