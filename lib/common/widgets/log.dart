import 'package:flutter/foundation.dart';

class Log {
  Log(var value) {
    if (!kReleaseMode)
      print("===============> ${value.toString()} <=====================");
  }
}
