

abstract class BottomNavigationEvent {
  const BottomNavigationEvent();
}

class BottomNavigationEventChangePage extends BottomNavigationEvent{
  const BottomNavigationEventChangePage(this.index);
  final int index;
}