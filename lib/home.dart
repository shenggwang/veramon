import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veramon/tool/song.dart';
import 'package:veramon/views/veradex.dart';
import 'package:veramon/views/game.dart';
import 'package:veramon/views/team.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  var _kTabPages = <Widget>[
    Team(),
    Game(),
    Veradex()
  ];
  var _kTabs = <Tab> [
    Tab(text: 'Team'),
    Tab(text: 'Game'),
    Tab(text: 'Veradex')
  ];

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _tabController = TabController(
      length: _kTabPages.length,
      vsync: this,
    );
    SONG.playBackgound();
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  void _settings(context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('TODO'),
        children: <Widget>[
          Center(child: Text('Settings')),
          Center(child: Text('Songs')),
          Center(
            child:RaisedButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context, 'Ok'),
            )
          )
        ],
      )
  ).then((returnValue){
    print('Value : $returnValue');
  });

  void _showLink(context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('TODO'),
        children: <Widget>[
          Center(child: Text('Links')),
          Center(
            child:RaisedButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context, 'Ok'),
            )
          )
        ],
      )
  ).then((returnValue){
    print('Value : $returnValue');
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Veramon'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          RaisedButton(
            child: Text('settings'),
            onPressed: () => _settings(context),
          ),
          RaisedButton(
            child: Text('info'),
            onPressed: () => _showLink(context),
          )
        ],
      ),
      body: TabBarView(
        children: _kTabPages,
        controller: _tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.green,
        child: TabBar(
          tabs: _kTabs,
          controller: _tabController,
        ),
      ),
    );
  }
}