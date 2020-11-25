

import 'dart:io';

import 'package:kpp01/typedef.dart';

abstract class SystemLanguageEvent {
  const SystemLanguageEvent();
}

class SystemLanguageEventChange extends SystemLanguageEvent {
     const SystemLanguageEventChange({
    this.systemLanguageCode,
  });
  final SystemLanguageCode systemLanguageCode;
}
