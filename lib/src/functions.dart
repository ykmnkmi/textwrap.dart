import 'package:textwrap/src/extensions.dart';
import 'package:textwrap/src/patterns.dart';

/// Fixes sentence endings by ensuring proper spacing after sentence terminators.
///
/// This function modifies the [chunks] list in-place by converting single spaces
/// after sentence endings (periods, exclamation marks, question marks) into
/// double spaces for proper typographic formatting.
///
/// Example:
/// ```dart
/// final chunks = ['Hello.', ' ', 'World!'];
/// fixEndings(chunks);
/// // chunks becomes ['Hello.', '  ', 'World!']
/// ```
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

/// Handles words that are longer than the available line width.
///
/// This function breaks long words to fit within the current line or moves
/// them to the next line based on the wrapping configuration. It modifies
/// [reversedChunks] and [currentLine] in-place.
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

/// Normalizes whitespace characters in text according to specified options.
///
/// This function can expand tabs to spaces and replace various whitespace
/// characters (tab, newline, vertical tab, form feed, carriage return) with
/// regular spaces.
///
/// Returns the normalized text string.
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
      9: 32, // tab -> space
      10: 32, // newline -> space
      11: 32, // vertical tab -> space
      12: 32, // form feed -> space
      13: 32, // carriage return -> space
    });
  }

  return text;
}

/// Splits text into chunks based on word boundaries and hyphenation rules.
///
/// This function breaks text at word separators, optionally preserving
/// hyphenation points for better line breaking control.
///
/// Returns a list of text chunks.
List<String> split(String text, {bool breakOnHyphens = true}) {
  List<String> chunks;

  if (breakOnHyphens) {
    chunks = wordSeparatorRe.split(text);
  } else {
    chunks = wordSeparatorSimpleRe.split(text);
  }

  return chunks;
}

/// Preprocesses text and splits it into chunks ready for wrapping.
///
/// This function combines whitespace normalization and text splitting into
/// a single operation, preparing text for the wrapping algorithm.
///
/// Returns a list of preprocessed text chunks.
List<String> splitChunks(
  String text, {
  bool expandTabs = true,
  bool replaceWhitespace = true,
  bool breakOnHyphens = true,
  int tabSize = 8,
}) {
  text = mungeWhitespace(
    text,
    expandTabs: expandTabs,
    replaceWhitespace: replaceWhitespace,
    tabSize: tabSize,
  );

  return split(text, breakOnHyphens: breakOnHyphens);
}

/// Core text wrapping algorithm that processes chunks into wrapped lines.
///
/// This is the main wrapping function that takes preprocessed text chunks
/// and arranges them into lines that fit within the specified width. It
/// handles indentation, long word breaking, whitespace management, and
/// line limits with truncation.
///
/// Returns a list of wrapped lines.
///
/// Throws [RangeError] if width is negative.
/// Throws [StateError] if placeholder is too large for the specified width.
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
    throw RangeError.range(
      width,
      0,
      null,
      'width',
      'Invalid width $width (must be > 0).',
    );
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
      handleLongWord(
        chunks,
        currentLine,
        currentLength,
        contentWidth,
        breakLongWords: breakLongWords,
        breakOnHyphens: breakOnHyphens,
      );

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
