import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nativeshell/accelerators.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:nativeshell/nativeshell.dart' as nativeshell_menu;
import 'package:storyrs/generated/l10n.dart';

// TODO: 为菜单栏项目添加实际点击效果
// MenuBar items
MenuBuilder buildMenu(
  S s, {
  VoidCallback? welcome,
}) =>
    () {
      return [
        if (Platform.isMacOS)
          nativeshell_menu.MenuItem.children(title: 'Storyrs', children: [
            nativeshell_menu.MenuItem.withRole(
              title: s.aboutStoryrs,
              role: nativeshell_menu.MenuItemRole.about,
            ),
            nativeshell_menu.MenuItem.separator(),
            nativeshell_menu.MenuItem(
              title: s.preference,
              accelerator: cmdOrCtrl + ",",
              action: () {},
            ),
            nativeshell_menu.MenuItem.separator(),
            nativeshell_menu.MenuItem.withRole(
              title: s.hide,
              role: nativeshell_menu.MenuItemRole.hide,
            ),
            nativeshell_menu.MenuItem.withRole(
              title: s.hideOthers,
              role: nativeshell_menu.MenuItemRole.hideOtherApplications,
            ),
            nativeshell_menu.MenuItem.withRole(
              title: s.showAll,
              role: nativeshell_menu.MenuItemRole.showAll,
            ),
            nativeshell_menu.MenuItem.separator(),
            nativeshell_menu.MenuItem.withRole(
              title: s.quit,
              role: nativeshell_menu.MenuItemRole.quitApplication,
            ),
          ]),
        nativeshell_menu.MenuItem.children(title: s.file, children: [
          nativeshell_menu.MenuItem(
            title: s.newFile,
            accelerator: cmdOrCtrl + 'n',
            action: () {},
          ),
          nativeshell_menu.MenuItem.separator(),
          nativeshell_menu.MenuItem(
            title: s.open,
            accelerator: cmdOrCtrl + 'o',
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.openRecent,
            action: () {},
          ),
          nativeshell_menu.MenuItem.separator(),
          nativeshell_menu.MenuItem(
            title: s.closeFile,
            accelerator: cmdOrCtrl + 'w',
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.saveFile,
            accelerator: cmdOrCtrl + 's',
            action: null,
          ),
          nativeshell_menu.MenuItem.separator(),
          nativeshell_menu.MenuItem(
            title: s.importFile,
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.exportFile,
            action: () {},
          ),
          nativeshell_menu.MenuItem.separator(),
          nativeshell_menu.MenuItem(
            title: s.printFile,
            action: null,
          ),
        ]),
        nativeshell_menu.MenuItem.children(title: s.edit, children: [
          nativeshell_menu.MenuItem(
            title: s.undo,
            accelerator: cmdOrCtrl + 'z',
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.redo,
            accelerator: shift + cmdOrCtrl + 'z',
            action: () {},
          ),
          nativeshell_menu.MenuItem.separator(),
          nativeshell_menu.MenuItem(
            title: s.cut,
            accelerator: cmdOrCtrl + 'x',
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.copy,
            accelerator: cmdOrCtrl + 'c',
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.paste,
            accelerator: cmdOrCtrl + 'v',
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.delete,
            accelerator: cmdOrCtrl + 'd',
            action: () {},
          ),
          nativeshell_menu.MenuItem(
            title: s.selectAll,
            accelerator: cmdOrCtrl + 'a',
            action: () {},
          ),
          nativeshell_menu.MenuItem.separator(),
          nativeshell_menu.MenuItem.children(title: s.insert, children: []),
          nativeshell_menu.MenuItem.separator(),
          nativeshell_menu.MenuItem.children(title: s.find, children: [
            nativeshell_menu.MenuItem(
              title: s.find2,
              accelerator: cmdOrCtrl + 'f',
              action: () {},
            ),
            nativeshell_menu.MenuItem(
              title: s.replace,
              accelerator: cmdOrCtrl + 'r',
              action: () {},
            ),
          ]),
        ]),
        nativeshell_menu.MenuItem.children(
          title: s.format,
          children: [],
        ),
        nativeshell_menu.MenuItem.children(
          title: s.view,
          children: [],
        ),
        if (Platform.isMacOS)
          nativeshell_menu.MenuItem.children(
              title: s.window,
              role: MenuRole.window,
              children: [
                nativeshell_menu.MenuItem.withRole(
                  title: s.minimize,
                  role: nativeshell_menu.MenuItemRole.minimizeWindow,
                ),
                nativeshell_menu.MenuItem.withRole(
                  title: s.zoom,
                  role: nativeshell_menu.MenuItemRole.zoomWindow,
                ),
                nativeshell_menu.MenuItem.separator(),
                nativeshell_menu.MenuItem(
                  title: s.welcome,
                  action: welcome,
                ),
              ]),
        nativeshell_menu.MenuItem.children(
          title: s.help,
          children: [
            nativeshell_menu.MenuItem(
              title: s.help2,
              action: () {},
            ),
          ],
        ),
      ];
    };

Widget buildMenuBarItem(
    BuildContext context, Widget child, MenuItemState itemState) {
  Color background;
  Color foreground;
  switch (itemState) {
    case MenuItemState.regular:
      background = Colors.transparent;
      foreground = Colors.grey.shade800;
      break;
    case MenuItemState.hovered:
      background = Colors.purple.withOpacity(0.2);
      foreground = Colors.grey.shade800;
      break;
    case MenuItemState.selected:
      background = Colors.purple.withOpacity(0.8);
      foreground = Colors.white;
      break;
    case MenuItemState.disabled:
      background = Colors.transparent;
      foreground = Colors.grey.shade800.withOpacity(0.5);
      break;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    color: background,
    child: DefaultTextStyle.merge(
      style: TextStyle(color: foreground),
      child: child,
    ),
  );
}
