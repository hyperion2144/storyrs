import 'package:flutter/material.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WindowConfiguration extends InheritedWidget {
  const WindowConfiguration({
    super.key,
    required super.child,
    required this.windowName,
    required this.windowTitle,
    required this.windowInitSize,
  });

  final String windowName;

  final String windowTitle;

  final Size windowInitSize;

  static WindowConfiguration of(BuildContext context) {
    final WindowConfiguration? result =
        context.dependOnInheritedWidgetOfExactType<WindowConfiguration>();
    assert(result != null, 'No WindowConfiguration found in context');
    return result!;
  }

  static Future<void> saveRestoreWindow(
      LocalWindow window, String windowName) async {
    final prefs = await SharedPreferences.getInstance();
    final geometry = await window.getGeometry();
    final pos = await window.savePositionToString();

    prefs.setDouble("${windowName}_width", geometry.contentSize!.width);
    prefs.setDouble("${windowName}_height", geometry.contentSize!.height);
    prefs.setString("${windowName}_pos", pos);
  }

  static Future<void> restoreWindow(
      LocalWindow window, String windowName, Size windowInitSize) async {
    final prefs = await SharedPreferences.getInstance();

    final width =
        prefs.getDouble("${windowName}_width") ?? windowInitSize.width;
    final height =
        prefs.getDouble("${windowName}_height") ?? windowInitSize.height;

    final pos = prefs.getString("${windowName}_pos");
    if (pos != null) {
      await window.restorePositionFromString(pos);
    }

    await window.setGeometry(Geometry(
      contentSize: Size(width, height),
    ));
  }

  @override
  bool updateShouldNotify(WindowConfiguration oldWidget) {
    return oldWidget.windowTitle != windowTitle;
  }
}
