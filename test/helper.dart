import "dart:io" show Platform, Directory;
import "package:path/path.dart";

import "package:dart_rocks/config.dart";


initConfig([file = 'config.yml']) {
  String path = _getConfigPath(file);
  Config.load(path);
}

_getConfigPath(file) {
  if (isAbsolute(file)) {
    return file;
  }

  String path = Directory.current.absolute.path + Platform.pathSeparator + file;
  return normalize(path);
}