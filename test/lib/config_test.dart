import "package:test/test.dart";

import "package:dart_rocks/config.dart";

main() {
  Config.config = {
    "server": {
      "port": 1,
      "host": 100
    },
    "list": ['test', 'test2'],
    "name": "Hello world",
  };

  test("Getting missing param", () {
    expect(Config.getParam('missing'), equals(null));
  });

  test("Getting string param", () {
    expect(Config.getParam('name'), equals('Hello world'));
    expect(Config.getParam('name.0'), equals(null));
    expect(Config.getParam('name.hello'), equals(null));
  });

  test("Getting list param", () {
    expect(Config.getParam('list'), equals(['test', 'test2']));
    expect(Config.getParam('list.0'), equals('test'));
    expect(Config.getParam('list.1'), equals('test2'));
    expect(Config.getParam('list.3'), equals(null));
  });

  test("Getting map", () {
    expect(Config.getParam('server'), equals({'port': 1, 'host': 100}));
    expect(Config.getParam('server.port'), equals(1));
    expect(Config.getParam('server.host'), equals(100));
    expect(Config.getParam('server.missing'), equals(null));
  });
}