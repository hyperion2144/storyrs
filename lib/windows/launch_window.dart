import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:nativeshell/nativeshell.dart' as nativeshell_menu_bar;
import 'package:storyrs/channels.dart';
import 'package:storyrs/generated/l10n.dart';
import 'package:storyrs/main.dart';
import 'package:storyrs/widgets/menu.dart';
import 'package:storyrs/widgets/restore_window.dart';
import 'package:storyrs/windows/editor_window.dart';

class MyData {
  static List<Map> data = [
    {
      "id": 1,
      "name": "Marchelle",
    },
    {
      "id": 2,
      "name": "Modesty",
    },
    {
      "id": 3,
      "name": "Maure",
    },
    {
      "id": 4,
      "name": "Myrtie",
    },
    {
      "id": 5,
      "name": "Winfred",
    }
  ];
}

class StoryListItem extends StatefulWidget {
  const StoryListItem({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.isSelected,
    required this.onClick,
  });

  final bool isSelected;
  final DateTime lastUpdated;
  final VoidCallback onClick;
  final String title;

  @override
  State<StoryListItem> createState() => _StoryListItemState();
}

class _StoryListItemState extends State<StoryListItem> {
  bool wait = false;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final configuration = WindowConfiguration.of(context);
    final window = Window.of(context);

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: widget.isSelected ? Colors.red[400] : MacosColors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: MacosListTile(
        onClick: () async {
          if (wait && widget.isSelected) {
            setState(() {
              wait = false;
            });

            await Window.create(EditorWindowState.toInitData(widget.title));
            await WindowConfiguration.saveRestoreWindow(
              window,
              configuration.windowName,
            );
            await window.onCloseRequested();
            return;
          }

          widget.onClick();
          setState(() {
            wait = true;
          });

          _timer = Timer(const Duration(seconds: 1), () {
            setState(() {
              wait = false;
            });
          });
        },
        leading: const Image(
          image: AssetImage('resources/StoryistDocument-Flat.icns'),
          width: 40,
          height: 40,
        ),
        title: Text(
          widget.title,
          style: MacosTheme.of(context).typography.title2.copyWith(
              color: widget.isSelected
                  ? MacosColors.textColor
                  : MacosColors.systemGrayColor),
        ),
        subtitle: Text(
          '${S.current.lastUpdatedAt} ${date_format.formatDate(widget.lastUpdated, [
                'yyyy',
                '-',
                'm',
                '-',
                'dd',
                ' ',
                'HH',
                ':',
                'nn'
              ])}',
          style: TextStyle(
            color: widget.isSelected
                ? MacosColors.textColor
                : MacosColors.systemGrayColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }
}

class LogoTitle extends StatelessWidget {
  const LogoTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30.0),
        const Image(
          width: 100.0,
          image: AssetImage('resources/mac_icon.icns'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            S.current.welcomeTitle,
            style: MacosTheme.of(context)
                .typography
                .largeTitle
                .copyWith(fontSize: 32),
          ),
        ),
        Text(
          "${S.current.version} 1.0",
          style: MacosTheme.of(context)
              .typography
              .headline
              .copyWith(color: MacosColors.systemGrayColor),
        )
      ],
    );
  }
}

class LaunchContentItem extends StatelessWidget {
  const LaunchContentItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onClick,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        width: 260.0,
        child: MacosListTile(
          leading: MacosIcon(
            icon,
            color: MacosColors.appleRed,
            size: 35.0,
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          onClick: onClick,
        ),
      ),
    );
  }
}

class LaunchContentView extends StatefulWidget {
  const LaunchContentView({
    super.key,
  });

  @override
  State<LaunchContentView> createState() => _LaunchContentViewState();
}

class _LaunchContentViewState extends State<LaunchContentView> {
  bool showLaunch = true;

  void _loadShowLaunches() async {
    final value = await getValue(
        KVStoreRequest(mode: KVMode.CONFIG, key: "show_launches"));
    setState(() {
      showLaunch = value ?? true;
    });
  }

  void _saveShowLaunches(bool value) {
    setState(() {
      showLaunch = value;
      putValue(KVStoreRequest(
          mode: KVMode.CONFIG, key: "show_launches", value: value));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadShowLaunches();
  }

  @override
  Widget build(BuildContext context) {
    S appLocalizations = S.current;

    return MacosScaffold(
      backgroundColor: MacosColors.white,
      toolBar: ToolBar(
        decoration: const BoxDecoration(color: MacosColors.white),
        height: 240.0,
        titleWidth: 400.0,
        centerTitle: true,
        dividerColor: MacosColors.transparent,
        onPanStart: (details) {
          Window.of(context).performDrag();
        },
        title: const LogoTitle(),
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    // TODO: 待添加点击效果
                    LaunchContentItem(
                      icon: CupertinoIcons.doc,
                      title: appLocalizations.createNewProject,
                      subtitle: appLocalizations.createNewProjectSubTitle,
                      onClick: () {},
                    ),

                    // LaunchContentItem(
                    //   icon: CupertinoIcons.question_circle,
                    //   title: appLocalizations.openGuide,
                    //   subtitle: appLocalizations.learnFeatures,
                    //   onClick: () {},
                    // ),
                    //
                    // LaunchContentItem(
                    //   icon: CupertinoIcons.globe,
                    //   title: appLocalizations.visitWebsite,
                    //   subtitle: appLocalizations.sampleFile,
                    //   onClick: () {},
                    // ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 260.0,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MacosCheckbox(
                        activeColor: MacosColors.appleRed,
                        value: showLaunch,
                        onChanged: _saveShowLaunches,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appLocalizations.showLaunchesWindow,
                        style: MacosTheme.of(context).typography.callout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LaunchWindow extends StatefulWidget {
  const LaunchWindow({
    super.key,
  });

  @override
  State<LaunchWindow> createState() => _LaunchWindowState();
}

class _LaunchWindowState extends State<LaunchWindow> {
  int selectIndex = 0;

  //TODO: 将staticData替换为从后台查询的数据。
  List<Map> staticData = MyData.data;

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
      endSidebar: Sidebar(
        topOffset: 0.0,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            itemCount: staticData.length,
            controller: scrollController,
            itemBuilder: (builder, index) {
              Map data = staticData[index];

              return StoryListItem(
                title: data['name'],
                lastUpdated: DateTime.now(),
                isSelected: selectIndex == index,
                onClick: () {
                  setState(() {
                    selectIndex = index;
                  });
                },
              );
            },
          ),
        ),
        minWidth: 300,
        isResizable: false,
        bottom: GestureDetector(
          onTap: () {
            _selectFile(window);
          },
          child: Text(
            S.current.openAnotherProject,
            style: MacosTheme.of(context)
                .typography
                .title3
                .copyWith(color: MacosColors.systemGrayColor),
          ),
        ),
      ),
      child: const LaunchContentView(),
    );
  }

  Future<void> _selectFile(LocalWindow window) async {
    final request = FileOpenRequest(parentWindow: Window.of(context).handle);
    final file = await showFileOpenDialog(request);
    if (file != null) {
      await openEditorWindow(file);
      await window.onCloseRequested();
    }
  }

  Future<void> openEditorWindow(String path) async {
    final window = await Window.create(EditorWindowState.toInitData(path));
    await window.show();
  }
}

class LaunchWindowState extends WindowState {
  final String windowName = "launch_window";

  final String windowTitle = "Welcome to Storyrs";

  final Size windowInitSize = const Size(780.0, 500.0);

  @override
  WindowSizingMode get windowSizingMode => WindowSizingMode.manual;

  @override
  Widget build(BuildContext context) {
    return ExamplesWindow(
      child: WindowConfiguration(
        windowName: windowName,
        windowTitle: windowTitle,
        windowInitSize: windowInitSize,
        child: const LaunchWindow(),
      ),
    );
  }

  @override
  Future<void> initializeWindow(Size contentSize) async {
    // if (Platform.isMacOS) {
    //   final s = await S.delegate.load(Locale(Intl.getCurrentLocale()));
    //   await Menu(buildMenu(s)).setAsAppMenu();
    // }
    await WindowConfiguration.restoreWindow(window, windowName, windowInitSize);
    await window.setStyle(WindowStyle(
      frame: WindowFrame.noTitle,
      canFullScreen: false,
      canMinimize: false,
      canMaximize: false,
      canResize: false,
    ));

    await addWindow(WindowInfo(name: windowName, window: window.handle));
    await window.setTitle(windowTitle);
    await window.show();
  }

  @override
  Future<void> windowCloseRequested() async {
    await WindowConfiguration.saveRestoreWindow(window, windowName);
    await removeWindow(windowName);
    await window.close();
  }

  static Map toInitData() => {
        "class": "launchWindow",
      };

  static LaunchWindowState? fromInitData(dynamic initData) {
    if (initData is Map && initData["class"] == "launchWindow") {
      return LaunchWindowState();
    }
    return null;
  }
}
