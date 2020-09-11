import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:veramon/database/jsonreader.dart';
import 'package:veramon/database/monster.dart';
import 'package:veramon/database/monsterDAO.dart';
import 'dart:async';

import 'package:veramon/views/battle.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Game();
  }
}

class _Game extends State<Game>{
  MonsterDao _monsterDao = MonsterDao();
  var _isLoading = true;
  Map dex;
  List<Monster> team;

  Future<void> _getGame() async {
    Map dexMap = await JsonReader.getDex();
    List<Monster> listTeam = await this._monsterDao.getAllSortedByName();
    setState(() {
      this.dex = dexMap;
      this.team = listTeam;
      this._isLoading = false;
    });

  }

  @override
  void initState(){
    super.initState();
    _getGame();
  }

  void _showMessage(context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Warning'),
        content: Text(
          'You have no monster to battle!',
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
            color: Colors.grey,
            child: new Center(
              child: new RefreshIndicator(
                child: _isLoading ? new CircularProgressIndicator() :
                new RaisedButton(
                  child: Text('Battle'),
                  onPressed: team.length == 0 ?
                  () => _showMessage(context)
                  :
                  () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => Battle()
                    )
                  ),
                ),
                onRefresh: _getGame,
              ),
            )
        )
    );
  }
}
