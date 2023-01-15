import 'package:meta/meta.dart';

import 'utils.dart';

/// Wrap a single paragraph of text.
List<String> wrap(
  String text, {
  int width = 70,
  String initialIndent = '',
  String subsequentIndent = '',
  bool expandTabs = true,
  bool replaceWhitespace = true,
  bool fixSentenceEndings = false,
  bool breakLongWords = true,
  bool dropWhitespace = true,
  bool breakOnHyphens = true,
  int tabSize = 8,
  int maxLines = -1,
  String placeholder = ' ...',
}) {
  var wrapper = TextWrapper(
    width: width,
    initialIndent: initialIndent,
    subsequentIndent: subsequentIndent,
    expandTabs: expandTabs,
    replaceWhitespace: replaceWhitespace,
    fixSentenceEndings: fixSentenceEndings,
    breakLongWords: breakLongWords,
    dropWhitespace: dropWhitespace,
    breakOnHyphens: breakOnHyphens,
    tabSize: tabSize,
    maxLines: maxLines,
    placeholder: placeholder,
  );

  return wrapper.wrap(text);
}

/// Fill a single paragraph of text.
String fill(
  String text, {
  int width = 70,
  String initialIndent = '',
  String subsequentIndent = '',
  bool expandTabs = true,
  bool replaceWhitespace = true,
  bool fixSentenceEndings = false,
  bool breakLongWords = true,
  bool dropWhitespace = true,
  bool breakOnHyphens = true,
  int tabSize = 8,
  int maxLines = -1,
  String placeholder = ' ...',
}) {
  var wrapper = TextWrapper(
    width: width,
    initialIndent: initialIndent,
    subsequentIndent: subsequentIndent,
    expandTabs: expandTabs,
    replaceWhitespace: replaceWhitespace,
    fixSentenceEndings: fixSentenceEndings,
    breakLongWords: breakLongWords,
    dropWhitespace: dropWhitespace,
    breakOnHyphens: breakOnHyphens,
    tabSize: tabSize,
    maxLines: maxLines,
    placeholder: placeholder,
  );

  return wrapper.fill(text);
}

/// Collapse and truncate the given text to fit in the given width.
String shorten(
  String text,
  int width, {
  int maxLines = 1,
  String initialIndent = '',
  String subsequentIndent = '',
  bool expandTabs = true,
  bool replaceWhitespace = true,
  bool fixSentenceEndings = false,
  bool breakLongWords = true,
  bool dropWhitespace = true,
  bool breakOnHyphens = true,
  int tabSize = 8,
  String placeholder = ' ...',
}) {
  var wrapper = TextWrapper(
    width: width,
    initialIndent: initialIndent,
    subsequentIndent: subsequentIndent,
    expandTabs: expandTabs,
    replaceWhitespace: replaceWhitespace,
    fixSentenceEndings: fixSentenceEndings,
    breakLongWords: breakLongWords,
    dropWhitespace: dropWhitespace,
    breakOnHyphens: breakOnHyphens,
    tabSize: tabSize,
    maxLines: maxLines,
    placeholder: placeholder,
  );
  return wrapper.fill(text.split(RegExp('\\s+')).join(' '));
}

class TextWrapper {
  static final RegExp _wordSeparatorRe = RegExp(
      '([\t\n\v\r ]+|(?<=[\\w!"\'&.,?])-{2,}(?=\\w)|[^\t\n\v\r ]+?'
      '(?:-(?:(?<=[^\\d\\W]{2}-)|(?<=[^\\d\\W]-[^\\d\\W]-))(?=[^\\d\\W]-?[^\\d\\W])|'
      '(?=[\t\n\v\r ]|\$)|(?<=[\\w!"\'&.,?])(?=-{2,}\\w)))');

  static final RegExp _wordSeparatorSimpleRe = RegExp('([\t\n\v\r ])+');

  static final RegExp _sentenceEndRe = RegExp('\\w[\\.\\!\\?][\\"\']?\$');

  TextWrapper(
      {this.width = 70,
      this.initialIndent = '',
      this.subsequentIndent = '',
      this.expandTabs = true,
      this.replaceWhitespace = true,
      this.fixSentenceEndings = false,
      this.breakLongWords = true,
      this.dropWhitespace = true,
      this.breakOnHyphens = true,
      this.tabSize = 8,
      this.maxLines = -1,
      this.placeholder = ' ...'})
      : wordSeparatorRe = _wordSeparatorRe,
        wordSeparatorSimpleRe = _wordSeparatorSimpleRe,
        sentenceEndRe = _sentenceEndRe;

  final int width;

  final String initialIndent;

  final String subsequentIndent;

  final bool expandTabs;

  final bool replaceWhitespace;

  final bool fixSentenceEndings;

  final bool breakLongWords;

  final bool dropWhitespace;

  final bool breakOnHyphens;

  final int tabSize;

  final int maxLines;

  final String placeholder;

  final RegExp wordSeparatorRe;

  final RegExp wordSeparatorSimpleRe;

  final RegExp sentenceEndRe;

  @protected
  String mungeWhitespace(String text) {
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

  @protected
  List<String> split(String text) {
    List<String> chunks;

    if (breakOnHyphens) {
      chunks = wordSeparatorRe.split(text);
    } else {
      chunks = wordSeparatorSimpleRe.split(text);
    }

    return chunks;
  }

  @protected
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

  @protected
  void handleLongWord(
    List<String> reversedChunks,
    List<String> currentLine,
    int currentLength,
    int width,
  ) {
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

  @protected
  List<String> wrapChunks(List<String> chunks) {
    if (width < 0) {
      throw Exception('Invalid width $width (must be > 0).');
    }

    var lines = <String>[];

    if (maxLines != -1) {
      var indent = maxLines > 1 ? subsequentIndent : initialIndent;

      if (indent.length + placeholder.trimLeft().length > width) {
        throw Exception('Placeholder too large for max width.');
      }
    }

    chunks = chunks.reversed.toList();

    while (chunks.isNotEmpty) {
      var currentLine = <String>[];
      var currentLength = 0;

      var indent = lines.isNotEmpty ? subsequentIndent : initialIndent;
      var width = this.width - indent.length;

      if (dropWhitespace && chunks.last.trim().isEmpty && lines.isNotEmpty) {
        chunks.removeLast();
      }

      while (chunks.isNotEmpty) {
        var length = chunks.last.length;

        if (currentLength + length <= width) {
          currentLine.add(chunks.removeLast());
          currentLength += length;
        } else {
          break;
        }
      }

      if (chunks.isNotEmpty && chunks.last.length > width) {
        handleLongWord(chunks, currentLine, currentLength, width);
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
                currentLength + placeholder.length <= width) {
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

              if (previousLine.length + placeholder.length <= width) {
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

  @protected
  List<String> splitChunks(String text) {
    text = mungeWhitespace(text);
    return split(text);
  }

  /// Reformat the single paragraph in 'text' so it fits in lines of no more than 'self.width' columns,
  /// and return a list of wrapped lines.
  List<String> wrap(String text) {
    var chunks = splitChunks(text);

    if (fixSentenceEndings) {
      fixEndings(chunks);
    }

    return wrapChunks(chunks);
  }

  /// Reformat the single paragraph in 'text' to fit in lines of no more than 'self.width' columns,
  /// and return a new string containing the entire wrapped paragraph.
  String fill(String text) {
    return wrap(text).join('\n');
  }
}
