import "package:redstone/redstone.dart" as app;
import "package:args/args.dart";
import "package:dart_rocks/config.dart";


ArgParser parser = new ArgParser()
  ..addOption('config', abbr: 'c', defaultsTo: null);


main(List<String> args) {
  ArgResults options = parser.parse(args);
  Config.load(options['config']);

  app.setupConsoleLog();
  app.start(port: Config.getParam('server.port'));
}