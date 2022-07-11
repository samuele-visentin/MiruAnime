class AnilistStatus {
  final String _value;
  String get value => _value;
  const AnilistStatus._init(this._value);

  static const current = AnilistStatus._init('CURRENT');
  static const completed = AnilistStatus._init('COMPLETED');
  static const planning = AnilistStatus._init('PLANNING');
  static const paused = AnilistStatus._init('PAUSED');
}