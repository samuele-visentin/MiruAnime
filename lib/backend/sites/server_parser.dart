
class ServerParser {
  final String _name;

  const ServerParser._(this._name);

  @override
  String toString() {
    return _name;
  }

  static const animeworld = ServerParser._('AnimeWorld Server');
  static const vvvvid = ServerParser._('VVVVID');
  static const streamtape = ServerParser._('Streamtape');
  static const server2 = ServerParser._('Server 2');
  static const doodStream = ServerParser._('DoodStream');
  static const userload = ServerParser._('Userload');
  static const youtube = ServerParser._('YouTube');
  static const streamlare = ServerParser._('Streamlare');
  static const vup = ServerParser._('VUP');
  static const none = ServerParser._('');
}

