import "package:test/test.dart";
import "package:dart_rocks/db.dart";

import "../helper.dart";


main() {
  initConfig();

  test("Establish connection", () async {
    try {
      await initConnection();
      expect(true, equals(true));
    } catch (e) {
      expect(false, equals(true));
    }
  });
}