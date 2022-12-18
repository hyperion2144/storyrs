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
import 'package:storyrs/widgets/iconfont.dart';
import 'package:storyrs/widgets/menu.dart';
import 'package:storyrs/widgets/pull_down_wrapper.dart';
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
  @override
  Widget build(BuildContext context) {
    final window = Window.of(context);
    if (Platform.isMacOS) {
      window.setWindowMenu(Menu(buildMenu(
        S.current,
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
      child: EditorView(),
    );
  }
}

class EditorView extends StatefulWidget {
  const EditorView({super.key});

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final searchFieldController = TextEditingController();

  final _sidebarBackgroundColor = const CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE8E8E8),
    darkColor: Color.fromARGB(255, 58, 58, 60),
  );

  final List<Widget> pages = [];

  bool coverTitle = false;
  int pageIndex = 0;

  double leftPaneWidth = 200;
  double rightPaneWidth = 200;
  bool showLeftPane = true;
  bool showRightPane = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double leadingWidth = showLeftPane
        ? media.size.width >= 700
            ? leftPaneWidth
            : 120
        : 120;
    double rightSpaceWidth = showRightPane ? rightPaneWidth - 60 : 0;
    double spaceWidth = media.size.width;
    if (showLeftPane) {
      spaceWidth -= leftPaneWidth;
    }
    if (showRightPane) {
      spaceWidth -= rightPaneWidth;
    }
    double titleSpaceWidth = spaceWidth / 2 - 455;
    if (!showLeftPane) {
      titleSpaceWidth -= leadingWidth;
    }
    spaceWidth = spaceWidth / 2 - 250;
    if (!showRightPane) {
      spaceWidth -= 70;
    }
    if (showLeftPane && !showRightPane) {
      spaceWidth += 70;
      titleSpaceWidth -= 60;
    }
    if (titleSpaceWidth < 0) {
      spaceWidth += titleSpaceWidth;
    }
    if (spaceWidth <= 0) {
      rightSpaceWidth += spaceWidth;
    }

    return MacosScaffold(
      toolBar: ToolBar(
        decoration: BoxDecoration(
          color: _sidebarBackgroundColor,
        ),
        onPanStart: (_) => Window.of(context).performDrag(),
        titleWidth: 200,
        leadingWidth: leadingWidth,
        leading: Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Row(
            children: [
              MacosIconButton(
                icon: MacosIcon(
                  CupertinoIcons.sidebar_left,
                  color: MacosTheme.brightnessOf(context).resolve(
                    const Color.fromRGBO(0, 0, 0, 0.5),
                    const Color.fromRGBO(241, 241, 242, 1.0),
                  ),
                  size: 20.0,
                ),
                boxConstraints: const BoxConstraints(
                  minHeight: 20,
                  minWidth: 20,
                  maxWidth: 48,
                  maxHeight: 38,
                ),
                onPressed: () => setState(() {
                  showLeftPane = !showLeftPane;
                }),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
        title: MouseRegion(
          onEnter: (_) {
            setState(() {
              coverTitle = true;
            });
          },
          onExit: (_) {
            setState(() {
              coverTitle = false;
            });
          },
          child: MacosPulldownButton(
            icon: CupertinoIcons.book,
            title: WindowConfiguration.of(context).windowTitle,
            style: MacosTheme.of(context).typography.title3.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
            alignment: Alignment.centerLeft,
            items: [
              MacosPulldownMenuWrapper(
                child: Container(),
              ),
            ],
          ),
        ),
        actions: [
          CustomToolbarItem(
            inToolbarBuilder: (context) => Container(
              width: 400.0,
              height: 30.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const CupertinoDynamicColor.withBrightness(
                  color: Color.fromRGBO(241, 241, 242, 1.0),
                  darkColor: Color.fromRGBO(105, 104, 103, 1.0),
                ),
              ),
              child: Row(
                children: [],
              ),
            ),
            inOverflowedBuilder: (context) => ToolbarOverflowMenuItem(
              label: "Status View",
              onPressed: () {},
            ),
          ),
          if (spaceWidth > 0) ToolBarSpacer(spacerUnits: spaceWidth / 32),
          ToolBarIconButton(
            label: "Goals",
            icon: MacosIcon(
              IconFont.target,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(241, 241, 242, 1.0),
              ),
              size: 20.0,
            ),
            showLabel: false,
          ),
          const ToolBarDivider(),
          if (rightSpaceWidth > 0)
            ToolBarSpacer(spacerUnits: rightSpaceWidth / 32),
          ToolBarIconButton(
            label: "Inspector",
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(241, 241, 242, 1.0),
              ),
              size: 20.0,
            ),
            showLabel: false,
            onPressed: () => setState(() {
              showRightPane = !showRightPane;
            }),
          ),
        ],
      ),
      children: [
        if (showLeftPane)
          ResizablePane(
            minWidth: 100,
            resizableSide: ResizableSide.right,
            startWidth: leftPaneWidth,
            windowBreakpoint: 700,
            onResized: (value) {
              setState(() {
                if (value < 150) {
                  showLeftPane = false;
                } else {
                  leftPaneWidth = value;
                }
              });
            },
            decoration: BoxDecoration(
              color: _sidebarBackgroundColor,
            ),
            builder: (context, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MacosSearchField(
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
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: MacosScrollbar(
                      controller: scrollController,
                      child: SidebarItems(
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
                  ),
                ],
              );
            },
          ),
        ContentArea(
          builder: (BuildContext context, ScrollController scrollController) {
            return quill.QuillEditor.basic(
              controller: _controller,
              readOnly: false, // true for view only mode
            );
          },
        ),
        if (showRightPane)
          ResizablePane(
            windowBreakpoint: 800,
            onResized: (value) => {
              if (value > 0)
                setState(() {
                  if (value < 150) {
                    showRightPane = false;
                  } else {
                    rightPaneWidth = value;
                  }
                })
            },
            decoration: BoxDecoration(
              color: _sidebarBackgroundColor,
            ),
            minWidth: 149,
            resizableSide: ResizableSide.left,
            startWidth: rightPaneWidth,
            builder: (context, controller) => Container(),
          )
      ],
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
    await window.setTitle(windowTitle);
    await WindowConfiguration.restoreWindow(window, windowName, windowInitSize);
    await window.setGeometry(Geometry(
      minContentSize: const Size(600, 400),
    ));
    await window.setStyle(WindowStyle(
      frame: WindowFrame.noTitle,
      trafficLightOffset: const Offset(20, 18),
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
