class MalStatus {
  final String _value;
  String get value => _value;
  const MalStatus._init(this._value);

  static const current = MalStatus._init('watching');
  static const completed = MalStatus._init('completed');
  static const planning = MalStatus._init('plan_to_watch');
  static const paused = MalStatus._init('on_hold');
}