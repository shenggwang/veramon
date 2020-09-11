import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:veramon/containers/chooseMonster.dart';
import 'dart:async';

import 'package:veramon/database/jsonreader.dart';
import 'package:veramon/database/monster.dart';
import 'package:veramon/database/monsterDAO.dart';

class Team extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Team();
  }
}

class _Team extends State<Team>{
  MonsterDao _monsterDao = MonsterDao();
  var _isLoading = true;
  Map dex;
  List<Monster> team;

  Future<void> _getTeam() async {
    Map dexMap = await JsonReader.getDex();
    List<Monster> listTeam = await this._monsterDao.getAllSortedByName();
    setState(() {
      this.dex = dexMap;
      this.team = listTeam;
      this._isLoading = false;
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

  chooseMonster(){
    var stat = {"stats": {
      "hp": 50.0,
      "attack": 10.0,
      "defense": 10.0,
      "speed": 10
    }};
    Monster monster = new Monster(number: 1, name: "new mosnter", level: 1, stats: stat);
    this._monsterDao.insert(monster);
    setState(() {
      this.team.add(monster);
    });
    return new ChooseMonster();
  }

  removeMonster(){
    Monster monster = this.team[0];
    setState(() {
      this.team = new List<Monster>();
    });
    this._monsterDao.delete(monster);
  }

  noMonster(){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('You have no Monster in your team!'),
            RaisedButton(
              child: Text('Do something'),
              onPressed: () => chooseMonster(),
            )
          ],
      )
    );
  }

  haveMonster(){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new RaisedButton(
            child: Text('Remove Monster'),
            onPressed: removeMonster,
          )
        ]
    );
  }

  @override
  void initState(){
    super.initState();
    _getTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
            color: Colors.grey,
            child: new Center(
              child: new RefreshIndicator(
                child: _isLoading ? new CircularProgressIndicator() :
                team.length == 0 ?
                noMonster() : new ListView.builder(
                  itemCount: this.team != null ? this.team.length : 0,
                  itemBuilder: (context, i){
                    var member = this.team[0];
                    print(member);
                    var mon = this.dex[member.number.toString()];
                    return ListTile(
                      trailing: Image.asset(mon['image']),
                      title: Text(mon['name']),
                      subtitle: Text(mon['type']),
                      /*
                        title: Text(mon['name']+': '+mon['type']),
                        subtitle: Text('hp '+member['stats']['current_hp'].toString()+'/'+
                            member['stats']['hp'].toString()+
                            '; attack '+member['stats']['defense'].toString()+
                            '; defense '+member['stats']['defense'].toString()+
                            '; speed '+member['stats']['speed'].toString()),
                         */
                    );
                  },
                ),
                onRefresh: _getTeam,
              ),
            )
        )
    );
  }
}