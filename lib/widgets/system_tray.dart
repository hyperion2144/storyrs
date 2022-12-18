import 'dart:io';

import 'package:storyrs/generated/l10n.dart';
import 'package:storyrs/widgets/actions.dart';
import 'package:system_tray/system_tray.dart';

const String _iconPathWin = 'resources/mac_icon.icns';

final SystemTray _systemTray = SystemTray();

Future<void> initSystemTray(S s) async {
  final SystemTray systemTray = SystemTray();

  // We first init the systray menu
  await systemTray.initSystemTray(
    // title: s.storyrs,
    toolTip: s.storyrs,
    iconPath: _iconPathWin,
  );

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(label: s.storyrs, enabled: false),
    MenuSeparator(),
    MenuItemLabel(label: s.preference, onClicked: (menuItem) => {}),
    MenuItemLabel(label: s.welcome, onClicked: (menuItem) => welcomeAction()),
    MenuSeparator(),
    MenuItemLabel(label: s.quit, onClicked: (menuItem) => exit(0)),
  ]);

  // set context menu
  await systemTray.setContextMenu(menu);

  // handle system tray event
  systemTray.registerSystemTrayEventHandler((eventName) {
    systemTray.popUpContextMenu();
  });
}
