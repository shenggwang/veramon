import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:veramon/database/jsonreader.dart';
import 'package:veramon/database/monster.dart';
import 'package:veramon/database/monsterDAO.dart';

class ChooseMonster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseMonster();
  }
}

class _ChooseMonster extends State<ChooseMonster>{
  MonsterDao _monsterDao = MonsterDao();
  Map dex;
  List<Monster> team;

  Future<void> _getMonster() async {
    Map dexMap = await JsonReader.getDex();
    List<Monster> listTeam = await this._monsterDao.getAllSortedByName();
    setState(() {
      this.dex = dexMap;
      this.team = listTeam;
    });
  }

  void _showMessage(context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Title'),
        content: Text(
          'TODO',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.pop(context, 'Ok'),
          )
        ],
      )
  ).then((returnValue){
    print('Value : $returnValue');
  });

  @override
  void initState(){
    super.initState();
    _getMonster();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.grey,
      child: new Center(
        child: new RefreshIndicator(
          child: new ListView.builder(
            itemCount: this.dex != null ? this.dex.length : 0,
            itemBuilder: (context, i){
              var mon = this.dex[(i+1).toString()];
              return ListTile(
                trailing: Image.asset(mon['image']),
                title: Text(mon['name']),
                subtitle: Text(mon['type']),
              );
            },
          ),
          onRefresh: _getMonster,
        ),
      )
    );
  }
}