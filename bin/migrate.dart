import "dart:io" show File, Platform, IOSink, Directory, FileSystemEntity, Process, ProcessResult;

import "package:args/args.dart";
import "package:path/path.dart";
import "package:dart_rocks/config.dart";
import "package:dart_rocks/db.dart";
import "package:objectory/objectory_console.dart";


const String Template = '_template.dart';


main(List<String> args) async {
  ArgResults options = _createParser().parse(args);
  Config.load(options['config']);

  await initConnection();

  if (options.command.name == 'create') {
    create(options.command['name']);
  } else if (options.command.name == 'up') {
    await up();
  } else if (options.command.name == 'down') {
    await down(int.parse(options.command['count']));
  }

  objectory.close();
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
  List<Migration> applied = await objectory[Migration].find();

  applied.forEach((Migration element) {
    if (migrations.containsKey(element.name)) {
      migrations.remove(element.name);
    }
  });

  for (var i = 0; i < migrations.keys.length; i++) {
    String name = migrations.keys.elementAt(i);
    String path = migrations[name];

    bool result = _upMigration(path);

    if (!result) {
      break;
    }

    Migration migration = new Migration();
    migration.path = path;
    migration.name = name;
    migration.time = new DateTime.now();
    await migration.save();
  }
}

/// Down migrations
down([count=0]) async {
  List<Migration> applied = await objectory[Migration].find(where.sortBy('time', descending: true).limit(count));


  for (var i = 0; i < applied.length; i++) {
    Migration migration = applied[i];

    bool result = _downMigration(migration.path);

    if (!result) {
      break;
    }

    await migration.remove();
  }
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

/// Up concrete migration
///
/// @return bool true, if success
bool _upMigration(String path) {
  print("== Up migration $path");
  ProcessResult result = Process.runSync('dart', [path, 'up']);

  print(result.stdout);
  print(result.stderr);

  if (result.exitCode == 0) {
    print("== Success");
  } else {
    print("== Error");
  }

  return result.exitCode == 0;
}

/// Down concrete migration
///
/// @return bool true, if success
bool _downMigration(String path) {
  print("== Down migration $path");
  ProcessResult result = Process.runSync('dart', [path, 'down']);

  print(result.stdout);
  print(result.stderr);

  if (result.exitCode == 0) {
    print("== Success");
  } else {
    print("== Error");
  }

  return result.exitCode == 0;
}