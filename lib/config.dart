import "dart:io";

import "package:yaml/yaml.dart";

class Config {

  static Map _config = {};

  static load(path) {
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

    if (data is List && data.length >= int.parse(key)) {
      key = int.parse(key);
      if (data.length >= key) {
        return null;
      }
    }

    var value = data[key];
    if (path.length == 0) {
      return value;
    }

    return _getParamRecursive(path, data: value);
  }

  static bool _isMappable(config) {
    return config is Map || config is YamlMap;
  }

}