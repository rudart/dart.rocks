import "dart:io";

import "package:yaml/yaml.dart";
import "package:path/path.dart" show dirname, normalize, isAbsolute;

class Config {

  static Map _config = {};

  static set config(value) => _config = value;

  static load([path=null]) {
    if (path == null) {
      path = dirname(Platform.script.toFilePath()) + '/../config.yml';
    }

    path = _getConfigPath(path);
    File configFile = new File(path);
    String content = configFile.readAsStringSync();

    _config = loadYaml(content);
  }

  static dynamic getParam(String key) {
    List path = key.split('.').reversed.toList();

    return _getParamRecursive(path);
  }

  static dynamic _getParamRecursive(List<String> path, {dynamic data: null}) {
    if (data == null) {
      data = _config;
    }

    var key = path.removeLast();

    if (_isMappable(data) && !data.containsKey(key)) {
      return null;
    }

    if (data is List) {
      key = int.parse(key);
      if (data.length <= key) {
        return null;
      }
    }

    var value = null;
    if (_isMappable(data) || data is List) {
      value = data[key];
    }

    if (path.length == 0) {
      return value;
    }

    return _getParamRecursive(path, data: value);
  }

  static bool _isMappable(config) {
    return config is Map || config is YamlMap;
  }

  static String _getConfigPath(file) {
    if (isAbsolute(file)) {
      return file;
    }

    String path = Directory.current.absolute.path + Platform.pathSeparator + file;
    return normalize(path);
  }

}