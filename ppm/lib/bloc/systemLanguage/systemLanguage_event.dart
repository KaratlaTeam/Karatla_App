

import 'dart:io';

import 'package:PPM/typedef.dart';

abstract class SystemLanguageEvent {
  const SystemLanguageEvent();
}

class SystemLanguageEventChange extends SystemLanguageEvent {
     const SystemLanguageEventChange({
    this.systemLanguageCode,
  });
  final SystemLanguageCode systemLanguageCode;
}
