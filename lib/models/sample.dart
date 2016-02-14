part of db;

class Sample extends PersistentObject  {

  String get collectionName => 'SampleCollection';

  String get name => getProperty('name');
  set name(String value) => setProperty('name',value);

  String get imgUrl => getProperty('imgUrl');
  set imgUrl(String value) => setProperty('imgUrl',value);

  String get category => getProperty('category');
  set category(String value) => setProperty('category',value);

  //List<Ingredient> get ingredients => getPersistentList(Ingredient,'ingredients');

  List<String> get ingredients => getProperty('ingredients');
  set ingredients (List<String> value) => setProperty('ingredients', value);

  int get rating => getProperty('rating');
  set rating(int value) {
    setProperty('rating',value);
    if (id != null) {
      save();
    }
  }

  String get directions => getProperty('directions');
  set directions(String value) => setProperty('directions',value);

  String get recipeId => id.toHexString();
}