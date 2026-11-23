import 'package:flutter/material.dart';

class PSQuizPanel extends StatelessWidget {
  const PSQuizPanel({super.key, required this.position, required this.child});

  final Animation<Offset> position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        // The selected tab icon extends slightly above the navigation bar.
        padding: const EdgeInsets.only(bottom: 12),
        child: SlideTransition(
          position: position,
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.scaleDown,
            child: child,
          ),
        ),
      ),
    );
  }
}
