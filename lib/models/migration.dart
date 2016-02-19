part of db;

class Migration extends PersistentObject  {

  String get collectionName => 'migrations';

  String get name => getProperty('name');
  set name(String value) => setProperty('name',value);

  DateTime get time => new DateTime.fromMicrosecondsSinceEpoch(getProperty('time'));
  set time(DateTime value) => setProperty('time',value.millisecond);
}