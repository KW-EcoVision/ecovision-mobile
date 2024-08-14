import 'package:eco_vision/view/const/EcoVisionColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EcoTextField extends StatefulWidget {
  final double width;
  final double height;
  final bool isPassword;
  final String? labelText;
  final double radius;
  final Icon? prefixIcon;

  const EcoTextField(
      {super.key,
      required this.width,
      required this.height,
      required this.radius,
      required this.isPassword,
      this.prefixIcon,
      this.labelText});

  @override
  State<EcoTextField> createState() => _EcoTextFeildState();
}

class _EcoTextFeildState extends State<EcoTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      // height: widget.height,
      decoration: BoxDecoration(
        // color: Colors.white,
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
              // fillColor: Colors.black,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                borderSide:
                    BorderSide(width: 1, color: EcoVisionColor.neonGreen),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
            )),
      ),
    );
  }
}
