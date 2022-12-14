import 'package:nativeshell/nativeshell.dart';
import 'package:storyrs/channels.dart';
import 'package:storyrs/windows/launch_window.dart';

void welcomeAction() async {
  final window = await getWindow("launch_window");
  if (window != null) {
    await Window(window.window).show();
  } else {
    await Window.create(LaunchWindowState.toInitData());
  }
}
