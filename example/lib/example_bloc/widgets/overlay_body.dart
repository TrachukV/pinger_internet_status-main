import 'package:flutter/material.dart';

class OverlayBody extends StatelessWidget {
  const OverlayBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.red.withOpacity(0.6),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: const Text(
          'Lost internet connection',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
