import 'dart:math';

import 'package:veramon/database/monster.dart';

class ALGORITHM {
  static double percentage(double value, double total){
    return (value * 100.0) / total;
  }
  static damage(){

  }
  static List<Monster> appear(Map dexMap){
    var rng = new Random.secure();
    var num = rng.nextInt(3)+1;
    List<Monster> list = new List<Monster>();
    for (var i = 0; i < num; i++) {
      var id = rng.nextInt(36)+1;
      print(dexMap[id.toString()]['stats']);
      list.add(new Monster(number: id, name: dexMap[id.toString()]['name'], level: 1, stats: {'stats': dexMap[id.toString()]['stats']}));
    }
    return list;
  }
  static success(){

  }
}