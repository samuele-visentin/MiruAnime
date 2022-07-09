
class ServerName {
  final String _name;

  const ServerName._(this._name);

  @override
  String toString() {
    return _name;
  }

  static const animeworld = ServerName._('AnimeWorld Server');
  static const vvvvid = ServerName._('VVVVID');
  static const streamtape = ServerName._('Streamtape');
  static const server2 = ServerName._('Server 2');
  static const doodStream = ServerName._('DoodStream');
  static const userload = ServerName._('Userload');
  static const youtube = ServerName._('YouTube');
  static const streamlare = ServerName._('Streamlare');
  static const vup = ServerName._('VUP');
  static const none = ServerName._('');
}

