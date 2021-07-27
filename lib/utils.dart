/// Extends [Pattern].
extension PatternUtils on Pattern {
  /// Split string by the occurrences of pattern.
  List<String> split(String text) {
    final result = <String>[];
    var lastEnd = 0;

    for (final match in allMatches(text)) {
      result.add(text.substring(lastEnd, match.start));
      lastEnd = match.end;

      for (var i = 0, len = match.groupCount; i < len; i++) {
        result.add(match.group(i + 1)!);
      }
    }

    result.add(text.substring(lastEnd));
    return result;
  }
}

/// Extends [String].
extension StringUtils on String {
  /// Return a copy where all tab characters are expanded using spaces.
  String expandTabs([int tabSize = 8]) {
    final buffer = StringBuffer();
    final units = runes.toList();
    final length = units.length;

    for (var i = 0, line = 0; i < length; i += 1, line += 1) {
      final char = units[i];

      if (char == 13 || char == 10) {
        line = -1;
        buffer.writeCharCode(char);
      } else if (char == 9) {
        final size = tabSize - (line % tabSize);
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
    final buffer = StringBuffer();

    for (final rune in runes) {
      buffer.writeCharCode(table.containsKey(rune) ? table[rune]! : rune);
    }

    return buffer.toString();
  }
}
