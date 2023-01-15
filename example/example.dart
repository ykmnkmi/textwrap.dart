// ignore_for_file: avoid_print

import 'package:textwrap/textwrap.dart';

void main() {
  var text = "Hello there, how are you this fine day?  I'm glad to hear it!";
  // 'Hello there,'
  // 'how are you'
  // 'this fine'
  // "day?  I'm"
  // 'glad to hear'
  // 'it!'
  print(wrap(text, width: 12));
}
