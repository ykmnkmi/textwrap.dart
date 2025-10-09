import 'package:meta/meta.dart';
import 'package:textwrap/utils.dart';

part 'src/patterns.dart';

/// Class for wrapping/filling text.
///
/// The base class consists of the [wrap] and [fill] methods; the other methods
/// just there for subclasses to override in order to tweak the default
/// behavior. If you want to completely replace the main wrapping algorithm,
/// you will probably have to override [wrapChunks].
///
/// Example:
/// ```dart
/// final wrapper = TextWrapper(width: 40, initialIndent: '  ');
/// final wrapped = wrapper.fill('Long text to be wrapped');
/// ```
base class TextWrapper {
  /// Creates a new instance with the specified configuration.
  const TextWrapper({
    this.width = 70,
    this.initialIndent = '',
    this.subsequentIndent = '',
    this.expandTabs = true,
    this.tabSize = 8,
    this.replaceWhitespace = true,
    this.fixSentenceEndings = false,
    this.breakLongWords = true,
    this.breakOnHyphens = true,
    this.dropWhitespace = true,
    this.maxLines = -1,
    this.placeholder = ' ...',
  });

  /// The maximum width of wrapped lines, (unless [breakLongWords] is `false`).
  final int width;

  /// String that will be oreoended to the first line of wrapped output.
  ///
  /// Counts towards the line's width.
  final String initialIndent;

  /// String that will be prepended to all lines save the first of wrapped
  /// output.
  ///
  /// Also counts towards each line's width.
  final String subsequentIndent;

  /// Expand tabs in input text to spaces before further processing.
  ///
  /// Each tab will become `0` .. [tabSize] spaces, depending on its position
  /// in its line.
  ///
  /// If `false`, each tab is treated as a single character.
  final bool expandTabs;

  /// Expand tabs in input text to spaces before further processing.
  ///
  /// Each tab will become `0` .. [tabSize] spaces, depending on its position.
  final int tabSize;

  /// Replace all whitespace characters in the input text by spaces after tab
  /// expansion.
  ///
  /// Note that if [expandTabs] is `false` and [replaceWhitespace] is `true`,
  /// every tab will be converted to a single space!
  final bool replaceWhitespace;

  /// Ensure that sentence-ending punctuation is always followed by two spaces.
  /// Off by default because the algorithm is (unavoidably) imperfect.
  final bool fixSentenceEndings;

  /// Break words longer than [width].
  ///
  /// If `false`, those words will not be broken, and some lines might be longer
  /// than [width].
  final bool breakLongWords;

  /// Allow breaking hyphenated words.
  ///
  /// If `true`, wrapping will occur preferably on whitespaces and right after
  /// hyphens part of compound words.
  final bool breakOnHyphens;

  /// Drop leading and trailing whitespace from lines.
  final bool dropWhitespace;

  /// Truncate wrapped lines.
  ///
  /// `-1` for no limit.
  final int maxLines;

  /// Append to the last line of truncated text.
  final String placeholder;

  /// Munge whitespace in text: expand tabs and convert all other whitespace
  /// characters to spaces.
  ///
  /// Eg. " foo\\tbar\\n\\nbaz" becomes " foo    bar  baz".
  @visibleForOverriding
  @visibleForTesting
  String mungeWhitespace(String text) {
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

  /// Split the text to wrap into indivisible chunks.
  /// Chunks are not quite the same as words; see [wrapChunks] for full details.
  ///
  /// As an example, the text
  /// ```text
  /// Look, goof-ball -- use the -b option!
  /// ```
  /// breaks into the following chunks:
  /// ```
  /// 'Look,', ' ', 'goof-', 'ball', ' ', '--', ' ',
  /// 'use', ' ', 'the', ' ', '-b', ' ', 'option!'
  /// ```
  /// if [breakOnHyphens] is `true`, or in:
  /// ```
  /// 'Look,', ' ', 'goof-ball', ' ', '--', ' ',
  /// 'use', ' ', 'the', ' ', '-b', ' ', option!'
  /// ```
  /// otherwise.
  @visibleForOverriding
  @visibleForTesting
  List<String> split(String text) {
    List<String> chunks;

    if (breakOnHyphens) {
      chunks = _wordSeparatorRe.split(text);
    } else {
      chunks = _wordSeparatorSimpleRe.split(text);
    }

    return chunks;
  }

  /// Correct for sentence endings buried in [chunks].
  ///
  /// Eg. when the original text contains `'... foo.\\nBar ...'`,
  /// [mungeWhitespace] and [split] will convert that to
  /// `[..., 'foo.', ' ', 'Bar', ...]` which has one too few spaces; this
  /// method simply changes the one space to two.
  @visibleForOverriding
  @visibleForTesting
  void fixEndings(List<String> chunks) {
    var i = 0;

    while (i < chunks.length - 1) {
      if (chunks[i + 1] == ' ' && _sentenceEndRe.hasMatch(chunks[i])) {
        chunks[i + 1] = '  ';
        i += 2;
      } else {
        i += 1;
      }
    }
  }

  /// Handle a chunk of text (most likely a word, not whitespace) that is too
  /// long to fit in any line.
  @visibleForOverriding
  @visibleForTesting
  void handleLongWord(
    int width,
    int chunkIndex,
    List<String> chunks,
    int currentLength,
    List<String> currentLine,
  ) {
    var spaceLeft = width < 1 ? 1 : width - currentLength;

    if (breakLongWords) {
      var chunk = chunks[chunkIndex];
      var end = spaceLeft;

      if (breakOnHyphens && chunk.length > spaceLeft) {
        var hyphen = chunk.substring(0, spaceLeft).lastIndexOf('-');

        if (hyphen > 0 && chunk[hyphen - 1] != '-') {
          end = hyphen + 1;
        }
      }

      currentLine.add(chunk.substring(0, end));
      chunks[chunkIndex] = chunk.substring(end);
    } else if (currentLine.isEmpty) {
      currentLine.add(chunks[chunkIndex]);
      chunks[chunkIndex] = ''; // Mark as processed
    }
  }

  /// Wrap a sequence of text chunks and return a list of lines of length
  /// [width] or less.
  ///
  /// If [breakLongWords] is `false`, some lines may be longer than this.
  ///
  /// Chunks correspond roughly to words and the whitespace between them: each
  /// chunk is indivisible (modulo 'breakLongWords'), but a line break can come
  /// between any two chunks.
  ///
  /// Chunks should not have internal whitespace; ie. a chunk is either all
  /// whitespace or a 'word'. Whitespace chunks will be removed from the
  /// beginning and end of lines, but apart from that whitespace is preserved.
  ///
  /// Throws [ArgumentError] if width is less than `1`.
  /// Throws [StateError] if placeholder is too large for the specified width.
  @visibleForOverriding
  @visibleForTesting
  List<String> wrapChunks(List<String> chunks) {
    if (width < 1) {
      throw ArgumentError.value(
        width,
        'width',
        'Invalid width $width (must be > 0).',
      );
    }

    if (maxLines != -1) {
      var indent = maxLines > 1 ? subsequentIndent : initialIndent;

      if (indent.length + placeholder.trimLeft().length > width) {
        throw StateError('Placeholder too large for max width.');
      }
    }

    var lines = <String>[];

    var chunkIndex = 0;

    while (chunkIndex < chunks.length) {
      var currentLine = <String>[];
      var currentLength = 0;

      var indent = lines.isNotEmpty ? subsequentIndent : initialIndent;
      var contentWidth = width - indent.length;

      if (dropWhitespace &&
          chunks[chunkIndex].trim().isEmpty &&
          lines.isNotEmpty) {
        chunkIndex += 1;
        continue;
      }

      while (chunkIndex < chunks.length) {
        var length = chunks[chunkIndex].length;

        if (currentLength + length <= contentWidth) {
          currentLine.add(chunks[chunkIndex]);
          currentLength += length;
          chunkIndex += 1;
        } else {
          break;
        }
      }

      if (chunkIndex < chunks.length &&
          chunks[chunkIndex].length > contentWidth) {
        handleLongWord(
          contentWidth,
          chunkIndex,
          chunks,
          currentLength,
          currentLine,
        );

        currentLength = 0;

        for (var i = 0; i < currentLine.length; i += 1) {
          currentLength += currentLine[i].length;
        }

        if (chunks[chunkIndex].isEmpty) {
          chunkIndex += 1;
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
            (chunkIndex >= chunks.length ||
                    dropWhitespace &&
                        chunkIndex + 1 == chunks.length &&
                        chunks[chunkIndex].trim().isEmpty) &&
                currentLength <= width) {
          lines.add(indent + currentLine.join());
        } else {
          var whileElse = true;

          while (currentLine.isNotEmpty) {
            if (currentLine.last.trim().isNotEmpty &&
                currentLength + placeholder.length <= contentWidth) {
              currentLine.add(placeholder);
              lines.add(indent + currentLine.join());
              whileElse = false;
              break;
            }

            var last = currentLine.removeLast();
            currentLength -= last.length;
          }

          if (whileElse) {
            if (lines.isNotEmpty) {
              var previousLine = lines.last.trimRight();

              if (previousLine.length + placeholder.length <= contentWidth) {
                lines[lines.length - 1] = previousLine + placeholder;
                break;
              }
            }

            lines.add(indent + placeholder.trimLeft());
          }

          break;
        }
      }
    }

    return lines;
  }

  @visibleForOverriding
  @visibleForTesting
  List<String> splitChunks(String text) {
    return split(mungeWhitespace(text));
  }

  /// Reformat the single paragraph in [text] so it fits in lines of no more
  /// than [width] columns, and return a list of wrapped lines.
  ///
  /// Tabs in [text] are expanded with [StringUtils.expandTabs], and all other
  /// whitespace characters (including newline) are converted to space.
  List<String> wrap(String text) {
    var chunks = splitChunks(text);

    if (fixSentenceEndings) {
      fixEndings(chunks);
    }

    return wrapChunks(chunks);
  }

  /// Reformat the single paragraph in [text] to fit in lines of no more than
  /// [width] columns, and return a new string containing the entire wrapped
  /// paragraph.
  String fill(String text) {
    return wrap(text).join('\n');
  }
}

/// Wrap a single paragraph of text, returning a list of wrapped lines.
///
/// Reformat the single paragraph in [text] so it fits in lines of no more than
/// [width] columns, and return a list of wrapped lines.
///
/// By default, tabs in [text] are expanded with [StringUtils.expandTabs], and
/// all other whitespace characters (including newline) are converted to space.
///
/// Example:
/// ```dart
/// wrap('This is a long line of text that needs wrapping', width: 20);
/// // ['This is a long line', 'of text that needs', 'wrapping']
/// ```
List<String> wrap(
  String text, {
  int width = 70,
  String initialIndent = '',
  String subsequentIndent = '',
  bool expandTabs = true,
  int tabSize = 8,
  bool replaceWhitespace = true,
  bool fixSentenceEndings = false,
  bool breakLongWords = true,
  bool breakOnHyphens = true,
  bool dropWhitespace = true,
  int maxLines = -1,
  String placeholder = ' ...',
}) {
  return TextWrapper(
    width: width,
    initialIndent: initialIndent,
    subsequentIndent: subsequentIndent,
    expandTabs: expandTabs,
    tabSize: tabSize,
    replaceWhitespace: replaceWhitespace,
    fixSentenceEndings: fixSentenceEndings,
    breakLongWords: breakLongWords,
    breakOnHyphens: breakOnHyphens,
    dropWhitespace: dropWhitespace,
    maxLines: maxLines,
    placeholder: placeholder,
  ).wrap(text);
}

/// Fill a single paragraph of text, returning a new string.
///
/// Reformat the single paragraph in [text] to fit in lines of no more than
/// [width] columns, and return a new string containing the entire wrapped
/// paragraph.
///
/// As with [wrap], tabs are expanded and other whitespace characters converted
/// to space.
///
/// Example:
/// ```dart
/// fill('This is a long line of text', width: 20);
/// // 'This is a long line\nof text'
/// ```
String fill(
  String text, {
  int width = 70,
  String initialIndent = '',
  String subsequentIndent = '',
  bool expandTabs = true,
  int tabSize = 8,
  bool replaceWhitespace = true,
  bool fixSentenceEndings = false,
  bool breakLongWords = true,
  bool breakOnHyphens = true,
  bool dropWhitespace = true,
  int maxLines = -1,
  String placeholder = ' ...',
}) {
  return TextWrapper(
    width: width,
    initialIndent: initialIndent,
    subsequentIndent: subsequentIndent,
    expandTabs: expandTabs,
    tabSize: tabSize,
    replaceWhitespace: replaceWhitespace,
    fixSentenceEndings: fixSentenceEndings,
    breakLongWords: breakLongWords,
    breakOnHyphens: breakOnHyphens,
    dropWhitespace: dropWhitespace,
    maxLines: maxLines,
    placeholder: placeholder,
  ).fill(text);
}

/// Collapse and truncate the given text to fit in the given width.
///
/// The text first has its whitespace collapsed.  If it then fits in the
/// [width], it is returned as is. Otherwise, as many words as possible are
/// joined and then the placeholder is appended:
/// ```dart
/// shorten('Hello  world!', width: 12)
/// // 'Hello world!'
/// shorten('Hello  world!', width: 11)
/// // 'Hello ...'
/// ```
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
  return fill(
    _spaceRe.split(text.trim()).join(' '),
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
}
