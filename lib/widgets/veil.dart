import 'package:flutter/widgets.dart';

class Veil extends StatefulWidget {
  const Veil({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return _VeilState();
  }

  static bool visible(BuildContext context) {
    final state = context
        .dependOnInheritedWidgetOfExactType<_VeilInheritedWidget>()
        ?.veilState;
    return (state?._absorbCount ?? 0) > 0;
  }

  static Future<T> show<T>(
      BuildContext context, Future<T> Function() callback) async {
    final state = context
        .dependOnInheritedWidgetOfExactType<_VeilInheritedWidget>()!
        .veilState;
    state.enable();
    try {
      return await callback();
    } finally {
      state.disable();
    }
  }
}

class _VeilState extends State<Veil> {
  @override
  Widget build(BuildContext context) {
    return _VeilInheritedWidget(
      veilState: this,
      child: AbsorbPointer(
        absorbing: _absorbCount > 0,
        child: widget.child,
      ),
    );
  }

  void enable() {
    ++_absorbCount;
    if (_absorbCount == 1) {
      setState(() {});
    }
  }

  void disable() {
    --_absorbCount;
    if (_absorbCount == 0) {
      setState(() {});
    }
  }

  int _absorbCount = 0;
}

class _VeilInheritedWidget extends InheritedWidget {
  const _VeilInheritedWidget({
    required super.child,
    required this.veilState,
  });

  final _VeilState veilState;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
