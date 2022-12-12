import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/channels.dart';
import 'package:storyrs/generated/l10n.dart' as app_localization;
import 'package:storyrs/main.dart';
import 'package:storyrs/widgets/restore_window.dart';
import 'package:storyrs/windows/editor_window.dart';

const String windowName = "launch_window";
const Size windowInitSize = Size(780.0, 500.0);

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

            // TODO: 打开指定项目.
            final window = Window.of(context);
            await Window.create(EditorWindowState.toInitData(widget.title));
            await saveRestoreWindow(window, windowName);
            await window.close();
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
          '${app_localization.S.of(context).lastUpdatedAt} ${formatDate(widget.lastUpdated, [
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
            app_localization.S.of(context).welcomeTitle,
            style: MacosTheme.of(context)
                .typography
                .largeTitle
                .copyWith(fontSize: 32),
          ),
        ),
        Text(
          "${app_localization.S.of(context).version} 1.0",
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

class LaunchContentView extends StatelessWidget {
  const LaunchContentView({
    super.key,
    required this.showLaunches,
    required this.changeShowLaunches,
  });

  final bool showLaunches;
  final ValueChanged<bool> changeShowLaunches;

  @override
  Widget build(BuildContext context) {
    app_localization.S appLocalizations = app_localization.S.of(context);

    return Builder(
      builder: (context) {
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
                            value: showLaunches,
                            onChanged: changeShowLaunches,
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
      },
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
  bool showLaunches = true;

  //TODO: 将staticData替换为从后台查询的数据。
  List<Map> staticData = MyData.data;

  void _loadShowLaunches() async {
    final value = await getValue(
        KVStoreRequest(mode: KVMode.CONFIG, key: "show_launches"));
    setState(() {
      showLaunches = value ?? true;
    });
  }

  void _saveShowLaunches(bool value) {
    setState(() {
      showLaunches = value;
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
    return MacosWindow(
      endSidebar: Sidebar(
        topOffset: 0.0,
        // decoration: const BoxDecoration(
        //   color: Color(0xFFF0F0F1),
        // ),
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
            _selectFile(context);
          },
          child: Text(
            app_localization.S.of(context).openAnotherProject,
            style: MacosTheme.of(context)
                .typography
                .title3
                .copyWith(color: MacosColors.systemGrayColor),
          ),
        ),
      ),
      child: LaunchContentView(
        showLaunches: showLaunches,
        changeShowLaunches: _saveShowLaunches,
      ),
    );
  }

  Future<void> _selectFile(BuildContext context) async {
    final request = FileOpenRequest(parentWindow: Window.of(context).handle);
    final file = await showFileOpenDialog(request);
    if (file != null) {
      await openEditorWindow(file);
      final window = Window.of(context);
      await window.close();
    }
  }

  Future<void> openEditorWindow(String path) async {
    final window = await Window.create(EditorWindowState.toInitData(path));
    await window.show();
  }
}

class LaunchWindowState extends WindowState {
  @override
  WindowSizingMode get windowSizingMode => WindowSizingMode.manual;

  @override
  Widget build(BuildContext context) {
    return const ExamplesWindow(
      child: LaunchWindow(),
    );
  }

  @override
  Future<void> initializeWindow(Size contentSize) async {
    await restoreWindow(window, windowName, windowInitSize);

    await window.setStyle(WindowStyle(
      frame: WindowFrame.noTitle,
      canFullScreen: false,
      canMinimize: false,
      canMaximize: false,
      canResize: false,
    ));

    await window.show();
  }

  @override
  Future<void> windowCloseRequested() async {
    await saveRestoreWindow(window, windowName);

    return super.windowCloseRequested();
  }
}
