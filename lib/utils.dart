/// Extends [Pattern].
extension PatternUtils on Pattern {
  /// Split string by the occurrences of pattern.
  List<String> split(String text) {
    var result = <String>[];
    var start = 0, end = 0;

    for (var match in allMatches(text)) {
      end = match.start;

      if (start < end) {
        result.add(text.substring(start, end));
      }

      for (var i = 0, count = match.groupCount; i < count; i++) {
        result.add(match.group(i + 1)!);
      }

      start = match.end;
    }

    if (start < text.length) {
      result.add(text.substring(start));
    }

    return result;
  }
}

/// Extends [String].
extension StringUtils on String {
  /// Return a copy where all tab characters are expanded using spaces.
  String expandTabs([int tabSize = 8]) {
    var buffer = StringBuffer();
    var units = runes.toList();
    var length = units.length;

    for (var i = 0, line = 0; i < length; i += 1, line += 1) {
      var char = units[i];

      if (char == 13 || char == 10) {
        line = -1;
        buffer.writeCharCode(char);
      } else if (char == 9) {
        var size = tabSize - (line % tabSize);
        buffer.write(' ' * size);
        line = -1;
      } else {
        buffer.writeCharCode(char);
      }
    }

    return buffer.toString();
  }

  /// Replace each character in the string using the given translation table.
  String translate(Map<int, int> table) {
    var buffer = StringBuffer();

    for (var rune in runes) {
      buffer.writeCharCode(table.containsKey(rune) ? table[rune]! : rune);
    }

    return buffer.toString();
  }
}
