import 'package:miru_anime/objectbox.g.dart';

class ObjectBox {
  static late final Store store;

  static Future<void> init() async {
    ObjectBox.store = await openStore();
  }
}