abstract class AppDataEvent{
  const AppDataEvent();
}

class AppDataEventGetData extends AppDataEvent{
  final int index;
  const AppDataEventGetData(this.index);
}
