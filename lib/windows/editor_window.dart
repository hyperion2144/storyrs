import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:macos_ui/macos_ui.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/generated/l10n.dart';
import 'package:storyrs/main.dart';
import 'package:storyrs/widgets/restore_window.dart';

const String windowName = "editor_window";
const Size windowInitSize = Size(1200.0, 800.0);

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
    return Container(
      constraints: const BoxConstraints(
        minHeight: 400.0,
        minWidth: 800.0,
      ),
      child: MacosWindow(
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
                child: Container(
                  child: quill.QuillEditor.basic(
                    controller: _controller,
                    readOnly: false, // true for view only mode
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditorWindowState extends WindowState {
  EditorWindowState(this.path);

  String path = "";

  @override
  Widget build(BuildContext context) {
    return const ExamplesWindow(
      child: EditorWindow(),
    );
  }

  @override
  WindowSizingMode get windowSizingMode => WindowSizingMode.manual;

  @override
  Future<void> initializeWindow(Size contentSize) async {
    await restoreWindow(window, windowName, windowInitSize);

    await window.setStyle(WindowStyle(
      frame: WindowFrame.noTitle,
    ));
    await window.show();
  }

  static dynamic toInitData(String path) => {
        "class": "editorWindow",
        "filePath": path,
      };

  static EditorWindowState? fromInitData(dynamic initData) {
    if (initData is Map && initData["class"] == "editorWindow") {
      return EditorWindowState(initData["filePath"]);
    }
    return null;
  }

  @override
  Future<void> windowCloseRequested() async {
    await saveRestoreWindow(window, windowName);

    return super.windowCloseRequested();
  }
}
