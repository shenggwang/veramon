import 'package:meta/meta.dart';

class Monster {

  int id;

  final int number;
  final String name;
  final int level;
  final stats;

  Monster({
    @required this.number,
    @required this.name,
    @required this.level,
    @required this.stats
  });

  static Monster fromMap(Map<String, dynamic> json) {
    return Monster(
        number : json['number'],
        name : json['name'],
        level : json['level'],
        stats : json['stats']
    );
  }

  Map<String, dynamic> toMap() =>
      {
        'number': number,
        'name': name,
        'level': level,
        'stats': stats
      };
}