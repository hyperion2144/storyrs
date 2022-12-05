import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

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

class StoryListItem extends StatelessWidget {
  const StoryListItem({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.isSelected,
    required this.onClick,
  });

  final String title;
  final DateTime lastUpdated;
  final bool isSelected;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.redAccent : MacosColors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: MacosListTile(
        onClick: onClick,
        onDoubleClick: () {
          // onClick();
          // TODO: open project.
          debugPrint('open project $title');
        },
        leading: const Image(
          image: AssetImage('assets/images/StoryistDocument-Flat.icns'),
          width: 50,
        ),
        title: Text(
          title,
          style: MacosTheme.of(context).typography.title2.copyWith(
              color: isSelected
                  ? MacosColors.textColor
                  : MacosColors.systemGrayColor),
        ),
        subtitle: Text(
          'updated at ${formatDate(lastUpdated, [
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
            color: isSelected
                ? MacosColors.textColor
                : MacosColors.systemGrayColor,
          ),
        ),
      ),
    );
  }
}

class HomeWindow extends StatefulWidget {
  const HomeWindow({
    super.key,
  });

  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  List<Map> staticData = MyData.data;
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        builder: (context, scrollController) => ListView.builder(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          itemCount: staticData.length,
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
        minWidth: 300,
        isResizable: false,
        bottom: GestureDetector(
          onTap: () {
            debugPrint('open new file');
          },
          child: Text(
            'Open Another Project...',
            style: MacosTheme.of(context)
                .typography
                .title3
                .copyWith(color: MacosColors.systemGrayColor),
          ),
        ),
      ),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MacosScaffold(
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Column(
                  children: [],
                );
              },
            )
          ],
        );
      },
    );
  }
}
