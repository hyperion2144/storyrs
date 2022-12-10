import 'package:flutter/cupertino.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveRestoreWindow(LocalWindow window, String name) async {
  final prefs = await SharedPreferences.getInstance();
  final geometry = await window.getGeometry();
  final pos = await window.savePositionToString();

  prefs.setDouble("${name}_width", geometry.contentSize!.width);
  prefs.setDouble("${name}_height", geometry.contentSize!.height);
  prefs.setString("${name}_pos", pos);
}

Future<void> restoreWindow(
    LocalWindow window, String name, Size initSize) async {
  final prefs = await SharedPreferences.getInstance();

  final width = prefs.getDouble("${name}_width") ?? initSize.width;
  final height = prefs.getDouble("${name}_height") ?? initSize.height;

  final pos = prefs.getString("${name}_pos");
  if (pos != null) {
    await window.restorePositionFromString(pos);
  }

  await window.setGeometry(Geometry(
    contentSize: Size(width, height),
  ));
}
