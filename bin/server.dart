import "dart:io" show Platform, Directory;

import "package:redstone/redstone.dart" as app;
import "package:args/args.dart";
import "package:path/path.dart" show dirname, normalize, isAbsolute;
import "package:dart_rocks/config.dart";


String configPath = normalize(dirname(Platform.script.toFilePath()) + '/..') + '/config.yml';

ArgParser parser = new ArgParser()
  ..addOption('config', abbr: 'c', defaultsTo: configPath);


main(List<String> args) {
  ArgResults options = parser.parse(args);
  initConfig(options['config']);

  app.setupConsoleLog();
  app.start(port: Config.getParam('server.port'));
}

initConfig(file) {
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