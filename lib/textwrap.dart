import 'package:textwrap/src/functions.dart';
import 'package:textwrap/src/patterns.dart';

/// Wraps a single paragraph of text to fit within specified line width.
///
/// Returns a list of strings, each representing a wrapped line. The text is
/// broken at word boundaries when possible, with various options for
/// controlling the wrapping behavior.
///
/// Example:
/// ```dart
/// final lines = wrap(
///   'This is a long line of text that needs wrapping',
///   width: 20,
/// );
/// // Returns: ['This is a long line', 'of text that needs', 'wrapping']
/// ```
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
  String placeholder = '...',
}) {
  var chunks = splitChunks(
    text,
    breakOnHyphens: breakLongWords,
    expandTabs: expandTabs,
    tabSize: tabSize,
    replaceWhitespace: replaceWhitespace,
  );

  if (fixSentenceEndings) {
    fixEndings(chunks);
  }

  return wrapChunks(
    chunks,
    width: width,
    initialIndent: initialIndent,
    subsequentIndent: subsequentIndent,
    breakLongWords: breakLongWords,
    dropWhitespace: dropWhitespace,
    breakOnHyphens: breakOnHyphens,
    maxLines: maxLines,
    placeholder: placeholder,
  );
}

/// Wraps a single paragraph of text and returns it as a single string.
///
/// This is a convenience function that calls [wrap] and joins the resulting
/// lines with newline characters.
///
/// Example:
/// ```dart
/// final wrapped = fill('This is a long line of text', width: 20);
/// // Returns: 'This is a long line\nof text'
/// ```
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
  String placeholder = '...',
}) {
  return wrap(
    text,
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
  ).join('\n');
}

/// Collapses whitespace and truncates text to fit within specified width.
///
/// This function first normalizes whitespace by collapsing multiple spaces
/// into single spaces, then wraps the text. It's useful for creating
/// abbreviated versions of text that fit in limited space.
///
/// Example:
/// ```dart
/// final short = shorten('This    has   multiple    spaces', 15);
/// // Returns: 'This has ...'
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
    text.split(spaceRe).join(' '),
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

/// A configurable text wrapper that provides object-oriented text wrapping.
///
/// This class allows you to configure text wrapping options once and then
/// apply them to multiple texts. All wrapping behavior is controlled through
/// constructor parameters.
///
/// Example:
/// ```dart
/// final wrapper = TextWrapper(width: 40, initialIndent: '  ');
/// final wrapped = wrapper.fill('Long text to be wrapped');
/// ```
class TextWrapper {
  /// Creates a new TextWrapper with the specified configuration.
  TextWrapper({
    this.width = 70,
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
    this.placeholder = ' ...',
  });

  /// The maximum width of wrapped lines (default: 70).
  final int width;

  /// String to prepend to the first line of wrapped output.
  final String initialIndent;

  /// String to prepend to all lines of wrapped output except the first.
  final String subsequentIndent;

  /// Whether to expand tabs to spaces before wrapping.
  final bool expandTabs;

  /// Whether to replace whitespace characters with spaces.
  final bool replaceWhitespace;

  /// Whether to fix sentence endings with proper spacing.
  final bool fixSentenceEndings;

  /// Whether to break words longer than [width].
  final bool breakLongWords;

  /// Whether to drop leading and trailing whitespace from lines.
  final bool dropWhitespace;

  /// Whether to break on hyphens in compound words.
  final bool breakOnHyphens;

  /// Number of spaces to use when expanding tabs.
  final int tabSize;

  /// Maximum number of lines to output (-1 for no limit).
  final int maxLines;

  /// String to append when text is truncated due to [maxLines].
  final String placeholder;

  /// Wraps the given [text] and returns a list of wrapped lines.
  ///
  /// Uses the configuration specified in the constructor to wrap the text.
  List<String> wrap(String text) {
    var chunks = splitChunks(
      text,
      breakOnHyphens: breakLongWords,
      expandTabs: expandTabs,
      tabSize: tabSize,
      replaceWhitespace: replaceWhitespace,
    );

    if (fixSentenceEndings) {
      fixEndings(chunks);
    }

    return wrapChunks(
      chunks,
      width: width,
      initialIndent: initialIndent,
      subsequentIndent: subsequentIndent,
      breakLongWords: breakLongWords,
      dropWhitespace: dropWhitespace,
      breakOnHyphens: breakOnHyphens,
      maxLines: maxLines,
      placeholder: placeholder,
    );
  }

  /// Wraps the given [text] and returns it as a single string.
  ///
  /// This is equivalent to calling [wrap] and joining the result with
  /// newline characters.
  String fill(String text) {
    return wrap(text).join('\n');
  }
}
