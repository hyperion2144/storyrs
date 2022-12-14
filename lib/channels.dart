// ignore_for_file: constant_identifier_names

import 'package:flutter/services.dart';
import 'package:nativeshell/nativeshell.dart';

/// File Open Channel
const fileOpenChannel = MethodChannel("file_open_dialog_channel");

class FileOpenRequest {
  FileOpenRequest({
    required this.parentWindow,
  });

  final WindowHandle parentWindow;

  Map serialize() =>
      {
        "parentWindow": parentWindow.value,
      };
}

Future<String?> showFileOpenDialog(FileOpenRequest request) async {
  return await fileOpenChannel.invokeMethod(
      "showFileOpenDialog", request.serialize());
}

/// KV Store Channel
const kvStoreChannel = MethodChannel("kv_store_channel");

enum KVMode {
  CONFIG,
  CACHE,
  DATA;
}

class KVStoreRequest {
  KVStoreRequest({required this.mode, required this.key, this.value});

  final KVMode mode;
  final String key;
  final dynamic value;

  Map serialize() =>
      {
        "mode": mode.name,
        "key": key,
        "value": value,
      };
}

Future<void> putValue(KVStoreRequest request) async {
  return await kvStoreChannel.invokeMethod("put", request.serialize());
}

Future<dynamic> getValue(KVStoreRequest request) async {
  return await kvStoreChannel.invokeMethod("get", request.serialize()) ?? true;
}

/// Window Manager Channel
const windowManagerChannel = MethodChannel("local_window_manager_channel");

class WindowInfo {
  WindowInfo({required this.name, required this.window});

  final String name;
  final WindowHandle window;

  Map serialize() =>
      {
        "name": name,
        "window": window.value,
      };

  static WindowInfo fromJson(Map<Object?, Object?> json) {
    return WindowInfo(
      name: json['name']! as String,
      window: WindowHandle(json['window']! as int),
    );
  }
}

Future<void> addWindow(WindowInfo window) async {
  return await windowManagerChannel.invokeMethod("add", window.serialize());
}

Future<WindowInfo?> getWindow(String name) async {
  final Map<Object?, Object?>? window =
  await windowManagerChannel.invokeMethod("get", name);

  return window == null ? null : WindowInfo.fromJson(window);
}

Future<int> getWindows() async {
  return await windowManagerChannel.invokeMethod("list");
}

Future<void> removeWindow(String name) async {
  return await windowManagerChannel.invokeMethod("remove", name);
}
