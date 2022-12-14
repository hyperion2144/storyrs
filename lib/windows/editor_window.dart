import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:macos_ui/macos_ui.dart';
import 'package:nativeshell/nativeshell.dart' as nativeshell_menu_bar;
import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/channels.dart';
import 'package:storyrs/generated/l10n.dart';
import 'package:storyrs/main.dart';
import 'package:storyrs/widgets/actions.dart';
import 'package:storyrs/widgets/menu.dart';
import 'package:storyrs/widgets/restore_window.dart';

class _ListItemIcon extends StatelessWidget {
  const _ListItemIcon(
    this.icon, {
    required this.pageIndex,
    required this.currentIndex,
  });

  final int pageIndex;
  final int currentIndex;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MacosIcon(
      icon,
      color: currentIndex == pageIndex
          ? MacosColors.white
          : MacosColors.systemRedColor,
    );
  }
}

class EditorWindow extends StatefulWidget {
  const EditorWindow({super.key});

  @override
  State<EditorWindow> createState() => _EditorWindowState();
}

class _EditorWindowState extends State<EditorWindow> {
  int pageIndex = 0;
  final searchFieldController = TextEditingController();

  final quill.QuillController _controller = quill.QuillController.basic();

  final List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    final window = Window.of(context);
    if (Platform.isMacOS) {
      window.setWindowMenu(Menu(buildMenu(
        S.current,
        welcome: welcomeAction,
      )));
    }

    return MacosWindow(
      titleBar: Platform.isMacOS
          ? null
          : TitleBar(
              onPanStart: (details) => window.performDrag(),
              title: nativeshell_menu_bar.MenuBar(
                menu: Menu(buildMenu(S.current)),
                itemBuilder: buildMenuBarItem,
              ),
            ),
      sidebar: Sidebar(
        minWidth: 300.0,
        maxWidth: 600.0,
        onPanStart: (details) {
          Window.of(context).performDrag();
        },
        top: MacosSearchField(
          placeholder: S.of(context).searchProject,
          controller: searchFieldController,
          onResultSelected: (result) {
            setState(() {
              // TODO: 将pageIndex根据result.SearchKey复原
              searchFieldController.clear();
            });
          },
          onChanged: (value) {
            // TODO: 根据输入，进行搜索，并将搜索结果保存到当前state
          },
          results: const [
            // TODO: 展示搜索结果
          ],
        ),
        builder: (context, scrollController) => SidebarItems(
          currentIndex: pageIndex,
          onChanged: (i) => setState(() {
            pageIndex = i;
          }),
          scrollController: scrollController,
          itemSize: SidebarItemSize.medium,
          isExpanded: true,
          selectedColor: Colors.red[400],
          items: [
            // TODO: 根据目录构造Items
            SidebarItem(
              leading: _ListItemIcon(
                pageIndex: 0,
                currentIndex: pageIndex,
                CupertinoIcons.briefcase,
              ),
              label: const Text("项目"),
              disclosureItems: [
                SidebarItem(
                  leading: _ListItemIcon(
                    pageIndex: 1,
                    currentIndex: pageIndex,
                    CupertinoIcons.doc_text,
                  ),
                  label: const Text("文稿"),
                  disclosureItems: [
                    const SidebarItem(
                      label: Text("第一章"),
                      disclosureItems: [
                        SidebarItem(
                          label: Text("第一节"),
                        ),
                        SidebarItem(
                          label: Text("第二节"),
                        ),
                        SidebarItem(
                          label: Text("第三节"),
                        )
                      ],
                    ),
                  ],
                ),
                SidebarItem(
                  leading: _ListItemIcon(
                    pageIndex: 6,
                    currentIndex: pageIndex,
                    CupertinoIcons.group,
                  ),
                  label: const Text("人物"),
                  disclosureItems: [
                    SidebarItem(
                      leading: _ListItemIcon(
                        pageIndex: 7,
                        currentIndex: pageIndex,
                        CupertinoIcons.person,
                      ),
                      label: const Text("路人甲"),
                    ),
                  ],
                ),
                SidebarItem(
                  leading: _ListItemIcon(
                    pageIndex: 8,
                    currentIndex: pageIndex,
                    CupertinoIcons.settings,
                  ),
                  label: const Text("设定"),
                  disclosureItems: [
                    SidebarItem(
                      leading: _ListItemIcon(
                        pageIndex: 9,
                        currentIndex: pageIndex,
                        CupertinoIcons.scribble,
                      ),
                      label: const Text("路人甲"),
                    ),
                  ],
                ),
                SidebarItem(
                  leading: _ListItemIcon(
                    pageIndex: 10,
                    currentIndex: pageIndex,
                    CupertinoIcons.photo_on_rectangle,
                  ),
                  label: const Text("图片"),
                  disclosureItems: [
                    SidebarItem(
                      leading: _ListItemIcon(
                        pageIndex: 11,
                        currentIndex: pageIndex,
                        CupertinoIcons.photo,
                      ),
                      label: const Text("花"),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      child: Center(
        child: Column(
          children: [
            quill.QuillToolbar.basic(controller: _controller),
            Expanded(
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditorWindowState extends WindowState {
  EditorWindowState({required this.windowTitle});

  final String windowTitle;
  final String windowName = "editor_window";
  final Size windowInitSize = const Size(1200.0, 800.0);

  @override
  Widget build(BuildContext context) {
    return ExamplesWindow(
      child: WindowConfiguration(
        windowName: windowName,
        windowTitle: windowTitle,
        windowInitSize: windowInitSize,
        child: const EditorWindow(),
      ),
    );
  }

  @override
  WindowSizingMode get windowSizingMode => WindowSizingMode.manual;

  @override
  Future<void> initializeWindow(Size contentSize) async {
    // if (Platform.isMacOS) {
    //   final s = await S.delegate.load(Locale(Intl.getCurrentLocale()));
    //   await Menu(buildMenu(s)).setAsAppMenu();
    // }
    await window.setTitle(windowTitle);
    await WindowConfiguration.restoreWindow(window, windowName, windowInitSize);
    await window.setStyle(WindowStyle(
      frame: WindowFrame.noTitle,
    ));
    await addWindow(WindowInfo(name: windowTitle, window: window.handle));
    await window.show();
  }

  @override
  Future<void> windowCloseRequested() async {
    await WindowConfiguration.saveRestoreWindow(window, windowName);
    await removeWindow(windowTitle);
    await window.close();
  }

  static Map toInitData(String path) => {
        "class": "editorWindow",
        "filePath": path,
      };

  static EditorWindowState? fromInitData(dynamic initData) {
    if (initData is Map && initData["class"] == "editorWindow") {
      return EditorWindowState(windowTitle: initData["filePath"]);
    }
    return null;
  }
}
