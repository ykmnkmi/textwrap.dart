/// Utility extensions for [Pattern] objects.
extension PatternUtils on Pattern {
  /// Splits [text] by occurrences of this pattern, including captured groups.
  ///
  /// Returns a list containing the parts of [text] separated by matches of this
  /// pattern. If the pattern contains capturing groups, the captured text is
  /// also included in the result.
  ///
  /// Example:
  /// ```dart
  /// final pattern = RegExp(r'(\d+)');
  /// final result = pattern.split('abc123def456ghi');
  /// // Returns: ['abc', '123', 'def', '456', 'ghi']
  /// ```
  List<String> split(
    String text, {
    bool includeEmptyStrings = false,
    @Deprecated('Use includeEmptyStrings instead.')
    bool inclideEmptyStrings = false,
  }) {
    var pattern = this;

    if (pattern is! RegExp) {
      return text.split(this);
    }

    includeEmptyStrings |= inclideEmptyStrings;

    var result = <String>[];
    var start = 0, end = 0;

    for (var match in pattern.allMatches(text)) {
      end = match.start;

      if (includeEmptyStrings || start < end) {
        result.add(text.substring(start, end));
      }

      for (var i = 1; i <= match.groupCount; i += 1) {
        result.add(match.group(i)!);
      }

      start = match.end;
    }

    if (includeEmptyStrings || start < text.length) {
      result.add(text.substring(start));
    }

    return result;
  }
}

/// Utility extensions for [String] objects.
extension StringUtils on String {
  /// Returns a copy where all tab characters are expanded using spaces.
  ///
  /// Each tab character is replaced with enough spaces to reach the next tab
  /// stop, which occurs every [tabSize] columns. If [tabSize] is 0, tab
  /// characters are removed. If [tabSize] is negative, an [ArgumentError] is
  /// thrown. The column position is reset at the beginning of each line (after
  /// CR or LF characters).
  ///
  /// Example:
  /// ```dart
  /// final text = 'hello\tworld';
  /// final expanded = text.expandTabs(4);
  /// // Returns: 'hello    world' (assuming 'hello' is 5 chars, adds 3 spaces)
  /// ```
  String expandTabs([int tabSize = 8]) {
    if (tabSize < 0) {
      throw ArgumentError.value(tabSize, 'tabSize', 'must be non-negative');
    }

    var buffer = StringBuffer();
    var units = runes.toList();
    var length = units.length;

    for (var i = 0, line = 0; i < length; i += 1, line += 1) {
      var char = units[i];

      if (char == 13 || char == 10) {
        line = -1;
        buffer.writeCharCode(char);
      } else if (char == 9) {
        if (tabSize > 0) {
          var size = tabSize - (line % tabSize);
          buffer.write(' ' * size);
          line = -1;
        }
      } else {
        buffer.writeCharCode(char);
      }
    }

    return buffer.toString();
  }

  /// Replaces each character using the given translation [table].
  ///
  /// The [table] maps Unicode code points (integers) to replacement code points.
  /// Characters not found in the table are left unchanged.
  ///
  /// Example:
  /// ```dart
  /// final text = 'hello';
  /// final table = {104: 72, 101: 69}; // h→H, e→E
  /// final result = text.translate(table);
  /// // Returns: 'HEllo'
  /// ```
  String translate(Map<int, int> table) {
    var buffer = StringBuffer();

    for (var rune in runes) {
      buffer.writeCharCode(table.containsKey(rune) ? table[rune]! : rune);
    }

    return buffer.toString();
  }
}
