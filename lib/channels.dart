import 'package:flutter/services.dart';
import 'package:nativeshell/nativeshell.dart';

const fileOpenChannel = MethodChannel("file_open_dialog_channel");
const kvStoreChannel = MethodChannel("kv_store_channel");

class FileOpenRequest {
  FileOpenRequest({
    required this.parentWindow,
  });

  final WindowHandle parentWindow;

  Map serialize() => {
        "parentWindow": parentWindow.value,
      };
}

Future<String?> showFileOpenDialog(FileOpenRequest request) async {
  return await fileOpenChannel.invokeMethod(
      "showFileOpenDialog", request.serialize());
}

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

  Map<String, dynamic> serialize() => {
        "mode": mode.name,
        "key": key,
        "value": value,
      };
}

Future<void> putValue(KVStoreRequest request) async {
  return await kvStoreChannel.invokeMethod("put", request.serialize());
}

Future<dynamic> getValue(KVStoreRequest request) async {
  return await kvStoreChannel.invokeMethod("get", request.serialize());
}
