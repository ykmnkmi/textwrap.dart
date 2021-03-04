import 'package:textwrap/textwrap.dart';

void main() {
  final text = "Hello there, how are you this fine day?  I'm glad to hear it!";
  // 'Hello there,'
  // 'how are you'
  // 'this fine'
  // "day?  I'm"
  // 'glad to hear'
  // 'it!'
  print(wrap(text, width: 12));
}
