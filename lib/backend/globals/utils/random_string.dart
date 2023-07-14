import 'dart:math';

String randomString(final int length) {
   const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
   final Random rnd = Random();
   return String.fromCharCodes(
       Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)))
   );
 }