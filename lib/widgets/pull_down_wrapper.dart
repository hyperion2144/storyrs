import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosPulldownMenuWrapper extends StatelessWidget
    implements MacosPulldownMenuEntry {
  const MacosPulldownMenuWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  double get itemHeight => double.infinity;
}
