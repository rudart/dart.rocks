import "dart:io" show File, Platform, IOSink, Directory, FileSystemEntity;

import "package:args/args.dart";
import "package:path/path.dart";
import "package:dart_rocks/config.dart";
import "package:dart_rocks/db.dart";


const String Template = '_template.dart';


main(List<String> args) async {
  ArgResults options = _createParser().parse(args);
  Config.load(options['config']);

  if (options.command.name == 'create') {
    create(options.command['name']);
  } else if (options.command.name == 'up') {
    await up();
  } else if (options.command.name == 'down') {
    down(int.parse(options.command['count']));
  }
}

/// Create new migration file from template
create(String name) {
  String fileName = 'm' + new DateTime.now().millisecondsSinceEpoch.toString() + '_' + name + '.dart';
  String path = _getMigrationPath();

  String template = new File(path + '/' + Template).readAsStringSync();

  File migration = new File(path + '/' + fileName);
  IOSink sink = migration.openWrite();
  sink.write(template);
  sink.close();
}

/// Run all migrations
up() async {
  Map<String, String> migrations = _getMigrationsList();
  print(migrations);
}


/// Down migrations
down([count=0]) {
  print('down ' + count.toString());
}

/// Create arguments parser
ArgParser _createParser() {
  ArgParser parser = new ArgParser()
    ..addOption('config', abbr: 'c', defaultsTo: null);

  ArgParser upCommand = new ArgParser();
  parser.addCommand('up', upCommand);

  ArgParser createCommand  = new ArgParser();
  parser.addCommand('create', createCommand)
    ..addOption('name');

  ArgParser downCommand = new ArgParser();
  parser.addCommand('down', downCommand)
    ..addOption('count', defaultsTo: '0');

  return parser;
}

/// Get migrations path (from config)
String _getMigrationPath() {
  String path = Config.getParam('migrationPath');

  if (isAbsolute(path)) {
    return path;
  }

  return normalize(dirname(Platform.script.toFilePath()) + '/../' + path);
}

/// Getting migrations list from config directory
///
/// Key of map is migration's name, value => path to file
Map<String, String> _getMigrationsList() {
  String path = _getMigrationPath();
  Directory migrationDir = new Directory(path);
  List<FileSystemEntity> files = migrationDir.listSync();

  Map<String, String> migrations = new Map<String, String>();
  files.forEach((FileSystemEntity entity) {
    String fileName = entity.path.replaceFirst(path + '/', '');
    if (fileName == Template) {
      return null;
    }

    migrations[fileName.replaceFirst('.dart', '')] = entity.path;
  });

  return migrations;
}
