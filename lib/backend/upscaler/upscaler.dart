import 'package:flutter/services.dart';

class Upscaler {
  static const platform = MethodChannel('org.loli.miruanime/upscaler');

  void show(final String url) {
    platform.invokeMethod('show', {'url': url});
  }
}
