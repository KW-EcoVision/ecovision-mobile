import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EcoTextField extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final bool isPassword;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Icon? prefixIcon;
  final void Function(String)? onChanged;
  final String? labelText;

  const EcoTextField(
      {super.key,
      required this.width,
      required this.height,
      required this.radius,
      required this.isPassword,
      required this.focusedBorderColor,
      required this.enabledBorderColor,
      this.prefixIcon,
      this.onChanged,
      this.labelText});

  @override
  State<EcoTextField> createState() => _EcoTextFeildState();
}

class _EcoTextFeildState extends State<EcoTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: TextField(
          obscureText: widget.isPassword,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              borderSide:
                  BorderSide(width: 1, color: widget.focusedBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              borderSide:
                  BorderSide(width: 1, color: widget.enabledBorderColor),
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
