import 'package:textwrap/src/extensions.dart';
import 'package:textwrap/src/patterns.dart';

void fixEndings(List<String> chunks) {
  for (var i = 0; i < chunks.length - 1;) {
    var chunk = chunks[i];
    var length = chunk.length;
    var input = length > 2 ? chunk.substring(length - 2) : chunk;

    if (chunks[i + 1] == ' ' && sentenceEndRe.hasMatch(input)) {
      chunks[i + 1] = '  ';
      i += 2;
    } else {
      i += 1;
    }
  }
}

void handleLongWord(
  List<String> reversedChunks,
  List<String> currentLine,
  int currentLength,
  int width, {
  bool breakLongWords = true,
  bool breakOnHyphens = true,
}) {
  var spaceLeft = width < 1 ? 1 : width - currentLength;

  if (breakLongWords) {
    var chunk = reversedChunks.last;
    var end = spaceLeft;

    if (breakOnHyphens && chunk.length > spaceLeft) {
      var hyphen = chunk.lastIndexOf('-');

      if (hyphen > 0 && chunk.substring(0, hyphen).contains('-')) {
        end = hyphen + 1;
      }
    }

    currentLine.add(chunk.substring(0, end));
    reversedChunks[reversedChunks.length - 1] = chunk.substring(end);
  } else if (currentLine.isEmpty) {
    currentLine.add(reversedChunks.removeLast());
  }
}

String mungeWhitespace(
  String text, {
  bool expandTabs = true,
  int tabSize = 8,
  bool replaceWhitespace = true,
}) {
  if (expandTabs) {
    text = text.expandTabs(tabSize);
  }

  if (replaceWhitespace) {
    text = text.translate(const <int, int>{
      9: 32,
      10: 32,
      11: 32,
      12: 32,
      13: 32,
    });
  }

  return text;
}

List<String> split(String text, {bool breakOnHyphens = true}) {
  List<String> chunks;

  if (breakOnHyphens) {
    chunks = wordSeparatorRe.split(text);
  } else {
    chunks = wordSeparatorSimpleRe.split(text);
  }

  return chunks;
}

List<String> splitChunks(
  String text, {
  bool expandTabs = true,
  bool replaceWhitespace = true,
  bool breakOnHyphens = true,
  int tabSize = 8,
}) {
  text = mungeWhitespace(text,
      expandTabs: expandTabs,
      replaceWhitespace: replaceWhitespace,
      tabSize: tabSize);
  return split(text, breakOnHyphens: breakOnHyphens);
}

List<String> wrapChunks(
  List<String> chunks, {
  int width = 70,
  String initialIndent = '',
  String subsequentIndent = '',
  bool breakLongWords = true,
  bool dropWhitespace = true,
  bool breakOnHyphens = true,
  int maxLines = -1,
  String placeholder = ' ...',
}) {
  if (width < 0) {
    throw Exception('Invalid width $width (must be > 0).');
  }

  var lines = <String>[];

  if (maxLines != -1) {
    var indent = maxLines > 1 ? subsequentIndent : initialIndent;

    if (indent.length + placeholder.trimLeft().length > width) {
      throw StateError('Placeholder too large for max width.');
    }
  }

  chunks = chunks.reversed.toList();

  while (chunks.isNotEmpty) {
    var currentLine = <String>[];
    var currentLength = 0;

    var indent = lines.isNotEmpty ? subsequentIndent : initialIndent;
    var contentWidth = width - indent.length;

    if (dropWhitespace && chunks.last.trim().isEmpty && lines.isNotEmpty) {
      chunks.removeLast();
    }

    while (chunks.isNotEmpty) {
      var length = chunks.last.length;

      if (currentLength + length <= contentWidth) {
        currentLine.add(chunks.removeLast());
        currentLength += length;
      } else {
        break;
      }
    }

    if (chunks.isNotEmpty && chunks.last.length > contentWidth) {
      handleLongWord(chunks, currentLine, currentLength, contentWidth,
          breakLongWords: breakLongWords, breakOnHyphens: breakOnHyphens);
      currentLength = 0;

      for (var line in currentLine) {
        currentLength += line.length;
      }
    }

    if (dropWhitespace &&
        currentLine.isNotEmpty &&
        currentLine.last.trim().isEmpty) {
      var last = currentLine.removeLast();
      currentLength -= last.length;
    }

    if (currentLine.isNotEmpty) {
      if (maxLines == -1 ||
          lines.length + 1 < maxLines ||
          (chunks.isEmpty ||
                  dropWhitespace &&
                      chunks.length == 1 &&
                      chunks.first.trim().isEmpty) &&
              currentLength <= width) {
        lines.add(indent + currentLine.join());
      } else {
        var not = true;

        while (currentLine.isNotEmpty) {
          if (currentLine.last.trim().isNotEmpty &&
              currentLength + placeholder.length <= contentWidth) {
            currentLine.add(placeholder);
            lines.add(indent + currentLine.join());
            not = false;
            break;
          }

          var last = currentLine.removeLast();
          currentLength -= last.length;
        }

        if (not) {
          if (lines.isNotEmpty) {
            var previousLine = lines.last.trimRight();

            if (previousLine.length + placeholder.length <= contentWidth) {
              lines[lines.length - 1] = previousLine + placeholder;
            }

            lines.add(indent + placeholder.trimLeft());
          }
        }

        break;
      }
    }
  }

  return lines;
}
