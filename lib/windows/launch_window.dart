import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/generated/l10n.dart' as app_localization;
import 'package:storyrs/pages/launch_page.dart';

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
        onClick: () {
          if (wait && widget.isSelected) {
            // TODO: 打开指定项目.
            debugPrint('open project ${widget.title}');

            setState(() {
              wait = false;
            });
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
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    return MacosIntrinsicWindow(
      minHeight: 500.0,
      minWidth: 800.0,
      performDrag: () {
        Window.of(context).performDrag();
      },
      endSidebar: Sidebar(
        topOffset: 0.0,
        decoration: const BoxDecoration(
          color: Color(0xFFEDECEC),
        ),
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
            // TODO: 打开所选择的文件项目
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
      child: const LaunchPage(),
    );
  }

  void _selectFile(BuildContext context) async {
    // final request = FileOpenRequest(parentWindow: Window.of(context).handle);
    // final file = await showFileOpenDialog(request);
    // setState(() {
    //   _selectedFileName = file != null ? basename(file) : null;
    //
    //   debugPrint("open project file: $_selectedFileName");
    // });

    const xType = XTypeGroup(
      label: 'story',
      extensions: <String>['storyrs'],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[xType],
      confirmButtonText:
          app_localization.S.of(context).openFileConfirmButtonText,
      initialDirectory: "~/Documents",
    );
    _selectedFileName = file?.path;
    setState(() {
      _selectedFileName = file?.name;

      debugPrint("open project file: $_selectedFileName");
    });
  }
}
