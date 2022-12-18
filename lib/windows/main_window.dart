import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/generated/l10n.dart';
import 'package:storyrs/main.dart';
import 'package:storyrs/widgets/menu.dart';
import 'package:storyrs/widgets/restore_window.dart';
import 'package:storyrs/widgets/system_tray.dart';

class MainWindowState extends WindowState {
  final String windowName = "main_window";

  final String windowTitle = "main";

  final Size windowInitSize = const Size(100.0, 100.0);

  @override
  WindowSizingMode get windowSizingMode => WindowSizingMode.manual;

  @override
  Widget build(BuildContext context) {
    return ExamplesWindow(
      child: Container(),
    );
  }

  @override
  Future<void> initializeWindow(Size contentSize) async {
    final s = await S.delegate.load(Locale(Intl.getCurrentLocale()));
    if (Platform.isMacOS) {
      await Menu(buildMenu(
        s,
      )).setAsAppMenu();
    }
    await initSystemTray(s);
    await WindowConfiguration.restoreWindow(window, windowName, windowInitSize);
    await window.setStyle(WindowStyle(frame: WindowFrame.noFrame));

    await window.setTitle(windowTitle);
    await window.hide();
  }
}
