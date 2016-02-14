library db;

import "package:objectory/objectory_console.dart";
import "config.dart";

part "models/sample.dart";


initConnection() async {
  objectory = new ObjectoryDirectConnectionImpl(
      _getConnectionString(),
      _registerModels,
      false
  );

  return await objectory.initDomainModel();
}

_registerModels() {
  objectory.registerClass(Sample, () => new Sample(), () => new List<Sample>());
}

_getConnectionString() {
  var host = Config.getParam('db.host');
  var port = Config.getParam('db.port');
  var dbName = Config.getParam('db.dbName');
  var username = Config.getParam('db.username');
  var password = Config.getParam('db.password');

  if (username is String && username.length > 0 && password is String && password.length > 0) {
    return "mongodb://$username@$password:$host:$port/$dbName";
  }

  return "mongodb://$host:$port/$dbName";
}
