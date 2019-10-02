import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathUtils {
  PathUtils._();

  static Future<Directory> getDocumentDir() async {
    if (Platform.isMacOS || Platform.isLinux) {
      return Directory('${Platform.environment['HOME']}/.config');
    } else if (Platform.isWindows) {
      return Directory('${Platform.environment['UserProfile']}\\.config');
    }
    return await getApplicationDocumentsDirectory();
  }
}
