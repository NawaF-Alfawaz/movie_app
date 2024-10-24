import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {super.key, required this.onPressed, this.color, required this.btnName});

  final VoidCallback onPressed;
  final Color? color;
  final String btnName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 150.0,
          height: 42.0,
          child: Text(
            btnName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
