import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:veramon/database/jsonreader.dart';

class Veradex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Veradex();
  }
}

class _Veradex extends State<Veradex>{

  var _isLoading = true;
  Map map;

  Future<void> _getVeramon() async {
    Map decodedMap = await JsonReader.getDex();
    setState(() {
      this.map = decodedMap;
      this._isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _getVeramon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
            color: Colors.grey,
            child: new Center(
              child: new RefreshIndicator(
                child: _isLoading ? new CircularProgressIndicator() :
                new ListView.builder(
                  itemCount: this.map != null ? this.map.length : 0,
                  itemBuilder: (context, i){
                    var mon = this.map[(i+1).toString()];
                    return ListTile(
                      trailing: Image.asset(mon['image']),
                      title: Text((i+1).toString()+' - '+mon['name']+': '+mon['type']),
                      subtitle: Text('STATS: hp '+mon['stats']['hp'].toString()+
                          '; defense '+mon['stats']['defense'].toString()+
                          '; defense '+mon['stats']['defense'].toString()+
                          '; speed '+mon['stats']['speed'].toString()),
                    );
                  },
                ),
                onRefresh: _getVeramon,
              ),
            )
        )
    );
  }
}