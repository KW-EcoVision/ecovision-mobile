import 'package:flutter/material.dart';

class EcoTextField extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final bool isPassword;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Icon? prefixIcon;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? labelText;
  final int? maxLine;

  const EcoTextField(
      {super.key,
      required this.width,
      required this.height,
      required this.radius,
      required this.isPassword,
      required this.focusedBorderColor,
      required this.enabledBorderColor,
      this.prefixIcon,
      this.suffix,
      this.onChanged,
      this.onSubmitted,
      this.labelText,
      this.maxLine});

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
        elevation: 2,
        child: TextField(
          maxLines: (widget.isPassword || widget.maxLine == null)
              ? 1
              : widget.maxLine,
          obscureText: widget.isPassword,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffix,
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
          onSubmitted: widget.onSubmitted,
        ),
      ),
    );
  }
}
