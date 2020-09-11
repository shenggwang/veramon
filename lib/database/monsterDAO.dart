import 'package:sembast/sembast.dart';
import 'package:veramon/database/sembastDB.dart';
import 'package:veramon/database/monster.dart';

class MonsterDao {
  static const String MONSTER_STORE_NAME = 'monsters';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _monsterStore = intMapStoreFactory.store(MONSTER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SembastDB.instance.database;

  Future insert(Monster monster) async {
    await _monsterStore.add(await _db, monster.toMap());
  }

  Future update(Monster monster) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(monster.id));
    await _monsterStore.update(
      await _db,
      monster.toMap(),
      finder: finder,
    );
  }

  Future delete(Monster monster) async {
    final finder = Finder(filter: Filter.byKey(monster.id));
    await _monsterStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Monster>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _monsterStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final monster = Monster.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      monster.id = snapshot.key;
      return monster;
    }).toList();
  }
}