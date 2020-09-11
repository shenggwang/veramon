import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:veramon/animation/attack_animation.dart';
import 'package:veramon/animation/dead_animation.dart';
import 'package:veramon/animation/defend_animation.dart';
import 'package:veramon/animation/run_animation.dart';
import 'package:veramon/database/monster.dart';
import 'package:veramon/database/monsterDAO.dart';
import 'package:veramon/tool/algorithm.dart';
import 'package:veramon/tool/enum.dart';
import 'dart:async';

import 'package:veramon/animation/idle_animation.dart';
import 'package:veramon/database/jsonreader.dart';

class Battle extends StatefulWidget {

  final List<Monster> team;
  final List<Monster> enemyTeam;

  const Battle({
    Key key,
    this.team,
    this.enemyTeam,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Battle();
  }
}

class _Battle extends State<Battle> with TickerProviderStateMixin{

  MonsterDao _monsterDao = MonsterDao();

  STATUS _status = STATUS.IDLE;
  STATUS _enemyStatus = STATUS.IDLE;

  // TODO this should be improved in case the team has more than one member
  double _hp;
  double _totalHP;
  double _percentageHP;
  double _enemyHP;
  double _enemyTotalHP;
  double _enemyPercentageHP;

  var _isLoading = true;
  Map dex;
  List<Monster> team;
  List<Monster> enemyTeam;

  _getEnemy(){
    //this._enemyHP = this.enemyTeam.elementAt(0).stats['hp'];
    //this._enemyTotalHP = this.enemyTeam.elementAt(0).stats['hp'];
    this._enemyHP = 50;
    this._enemyTotalHP = 50;
    this._enemyPercentageHP = ALGORITHM.percentage(_enemyHP, _enemyTotalHP);
  }
  _getMonster(){
    //this._hp = this.team.elementAt(0).stats['hp'];
    //this._totalHP = this.team.elementAt(0).stats['hp'];
    this._hp = 50;
    this._totalHP = 50;
    this._percentageHP = ALGORITHM.percentage(_hp, _totalHP);
  }

  Future<void> _getBattle() async {
    Map dexMap = await JsonReader.getDex();
    List<Monster> listEnemyTeam = ALGORITHM.appear(dexMap);
    List<Monster> listTeam = await this._monsterDao.getAllSortedByName();
    setState(() {
      this.dex = dexMap;
      this.team = listTeam;
      this.enemyTeam = listEnemyTeam;
      _getMonster();
      _getEnemy();
      this._isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _getBattle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  animationStatus(){
    switch (this._status) {
      case STATUS.ATTACK:
        return AttackAnimation(
          enemy: false,
          image: Image.asset(this.dex[this.team.elementAt(0).number.toString()]['image']),
          idle: this._idle,
          defend: this._enemyDefend,
        );
      case STATUS.DEFEND:
        return DefendAnimation(
          enemy: false,
          image: Image.asset(this.dex[this.team.elementAt(0).number.toString()]['image']),
        );
      case STATUS.DEAD:
        return DeadAnimation(
          image: Image.asset(this.dex[this.team.elementAt(0).number.toString()]['image']),
        );
      case STATUS.RUN:
        return RunAnimation(
          image: Image.asset(this.dex[this.team.elementAt(0).number.toString()]['image']),
        );
      default:
        return IdleAnimation(
          enemy: false,
          image: Image.asset(this.dex[this.team.elementAt(0).number.toString()]['image']),
        );
    }
  }

  enemyAnimationStatus(){
    print(this.enemyTeam.elementAt(0).number.toString());
    switch (this._enemyStatus) {
      case STATUS.ATTACK:
        return AttackAnimation(
          enemy: true,
          image: Image.asset(this.dex[this.enemyTeam.elementAt(0).number.toString()]['image']),   // TODO retrieve the images as above method
        );
      case STATUS.DEFEND:
        return DefendAnimation(
          enemy: true,
          image: Image.asset(this.dex[this.enemyTeam.elementAt(0).number.toString()]['image']),
          idle: this._enemyIdle,
        );
      case STATUS.DEAD:
        return DeadAnimation(
          image: Image.asset(this.dex[this.enemyTeam.elementAt(0).number.toString()]['image']),
        );
      case STATUS.RUN:
      default:
        return IdleAnimation(
          enemy: true,
          image: Image.asset(this.dex[this.enemyTeam.elementAt(0).number.toString()]['image']),
        );
    }
  }

  void _idle(){
    setState(() {
      _status = STATUS.IDLE;
      _isLoading = false;
    });
  }

  void _battleOptions(context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Attacks'),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Tackle'),
                      onPressed: () => Navigator.pop(context, '1'),
                    ),
                    RaisedButton(
                      child: Text('Tickle'),
                      onPressed: () => Navigator.pop(context, '2'),
                    )
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Bite'),
                      onPressed: () => Navigator.pop(context, '1'),
                    ),
                    RaisedButton(
                      child: Text('Kick'),
                      onPressed: () => Navigator.pop(context, '2'),
                    )
                  ]
              )
            ]
          )
        ],
      )
  ).then((returnValue){
    if(returnValue!=null)
      this._attack(returnValue);
    else
      setState(() {
        _isLoading = false;
      });
  });

  void _attack(value){
    switch(value){
      case '1':
        setState(() {
          _status = STATUS.ATTACK;
          _isLoading = true;
        });
        break;
      case '2':
        setState(() {
          _status = STATUS.ATTACK;
          _isLoading = true;
        });
        break;
      default:
        setState(() {
          _isLoading = true;
        });
    }
  }

  void _defend(){
    setState(() {
      _status = STATUS.DEFEND;
    });
  }

  void _item(){
    setState(() {
      _status = STATUS.ATTACK;
    });
  }

  void _team(){
    setState(() {
      _status = STATUS.ATTACK;
    });
  }

  void _run(){
    setState(() {
      _status = STATUS.RUN;
    });
  }

  void _enemyIdle(){
    setState(() {
      _enemyStatus = STATUS.IDLE;
    });
  }

  void _enemyAttack(){
    setState(() {
      _enemyStatus = STATUS.ATTACK;
    });
  }

  void _enemyDefend(){
    double reducedHP = _enemyHP - 10.0;
    if(reducedHP > 0)
      setState(() {
        this._enemyStatus = STATUS.DEFEND;
        this._enemyHP = reducedHP;
      });
    else
      setState(() {
        this._enemyStatus = STATUS.DEAD;
        this._enemyHP = 0;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text('Battle'),
        centerTitle: true,
        title: Text('Veramon'),
        backgroundColor: Colors.green,
      ),
      body: new Container(
        color: Colors.grey,
        child: new Center(
          child: this.enemyTeam==null||this.team==null?null:Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new RefreshIndicator(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(this.enemyTeam.elementAt(0).name),
                                Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      width: ALGORITHM.percentage(this._enemyHP, this._enemyTotalHP),
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      duration: Duration(seconds: 1),
                                    )
                                  ],
                                ),
                                Text('$_enemyHP/$_enemyTotalHP ($_enemyPercentageHP%)'),
                              ]
                          ),
                          Container(
                            child: enemyAnimationStatus(),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            child: animationStatus(),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(this.team.elementAt(0).name),
                                Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      // Use the properties stored in the State class.
                                      width: ALGORITHM.percentage(this._hp, this._totalHP),
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      // Define how long the animation should take.
                                      duration: Duration(seconds: 1),
                                    )
                                  ],
                                ),
                                Text('$_hp/$_totalHP ($_percentageHP%)'),
                              ]
                          ),

                        ],
                      )
                    ]
                ),
                onRefresh: _getBattle,
              ),
              new Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Battle'),
                          onPressed: _isLoading ? null : () => {
                            this._battleOptions(context)
                          }
                        ),
                        RaisedButton(
                          child: Text('Team'),
                          onPressed: _isLoading ? null : () => print('pressed')
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Item'),
                          onPressed: _isLoading ? null : () => print('pressed')
                        ),
                        RaisedButton(
                          child: Text('Run'),
                          onPressed: _isLoading ? null : () => {
                            _run(),
                          }
                        )
                      ],
                    ),
                  ]
                )
              )
            ],
          ),
        )
      )
    );
  }
}