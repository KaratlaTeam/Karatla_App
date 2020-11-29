

import 'package:PPM/dataModel/scheduleModel.dart';

abstract class SchedeluEvent{}

class SchedeluEventChange extends SchedeluEvent{
  SchedeluEventChange(
    this.schedeluModel,
  );
  final SchedeluModel schedeluModel;
}

class SchedeluEventChangeToFinish extends SchedeluEvent{}



