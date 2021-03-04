/// Extends [Pattern].
extension PatternUtils on Pattern {
  /// Split string by the occurrences of pattern.
  List<String?> split(String text) {
    final matches = allMatches(text).toList();

    if (matches.isEmpty) {
      return <String>[text];
    }

    final result = <String?>[];
    final length = matches.length;
    Match? match;

    for (var i = 0, start = 0; i < length; i += 1, start = match.end) {
      match = matches[i];
      result.add(text.substring(start, match.start));

      if (match.groupCount > 0) {
        result.addAll(match.groups(List<int>.generate(match.groupCount, (index) => index + 1)));
      }
    }

    if (match != null) {
      result.add(text.substring(match.end));
    }

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
