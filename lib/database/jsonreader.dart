import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static getDex() async {
    var dex = await rootBundle.loadString('assets/veradex.json');
    Map dexMap = json.decode(dex);
    return dexMap;
  }
}