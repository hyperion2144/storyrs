import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/generated/l10n.dart' as app_localization;

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  // TODO: 是否展示启动界面的开关，应该从后台读取数据
  bool isShowLaunches = true;

  @override
  Widget build(BuildContext context) {
    app_localization.S appLocalizations = app_localization.S.of(context);

    return Builder(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            height: 240.0,
            titleWidth: 400.0,
            centerTitle: true,
            dividerColor: MacosColors.transparent,
            performDrag: () {
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
                        LaunchItem(
                          icon: CupertinoIcons.doc,
                          title: appLocalizations.createNewProject,
                          subtitle: appLocalizations.createNewProjectSubTitle,
                          onClick: () {},
                        ),
                        LaunchItem(
                          icon: CupertinoIcons.question_circle,
                          title: appLocalizations.openGuide,
                          subtitle: appLocalizations.learnFeatures,
                          onClick: () {},
                        ),

                        LaunchItem(
                          icon: CupertinoIcons.globe,
                          title: appLocalizations.visitWebsite,
                          subtitle: appLocalizations.sampleFile,
                          onClick: () {},
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 260.0,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // TODO: 此处选择框需要将值保存下来
                          MacosCheckbox(
                            activeColor: MacosColors.appleRed,
                            value: isShowLaunches,
                            onChanged: (value) {
                              setState(() {
                                isShowLaunches = value;
                              });
                            },
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

class LaunchItem extends StatelessWidget {
  const LaunchItem({
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
