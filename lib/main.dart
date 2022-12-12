import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/generated/l10n.dart';
import 'package:storyrs/windows/editor_window.dart';
import 'package:storyrs/windows/launch_window.dart';

void main() async {
  runApp(const MyApp());
}

// Common scaffold code used by each window
class ExamplesWindow extends StatelessWidget {
  const ExamplesWindow({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      onGenerateTitle: (context) {
        return S.of(context).storyrs;
      },
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: true,
      home: WindowLayoutProbe(
        child: child,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowWidget(
      onCreateState: (initData) {
        WindowState? state;

        state ??= EditorWindowState.fromInitData(initData);
        state ??= LaunchWindowState();
        return state;
      },
    );
  }
}
