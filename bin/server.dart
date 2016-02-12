import "dart:io" show Platform;

import "package:redstone/redstone.dart" as app;
import "package:dart_rocks/config.dart";
import "package:path/path.dart" show dirname, normalize;

String configPath = normalize(dirname(Platform.script.toFilePath()) + '/..') + '/config.yaml';



main() {

}