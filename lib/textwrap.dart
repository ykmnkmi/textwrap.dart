import 'package:textwrap/src/functions.dart';
import 'package:textwrap/src/patterns.dart';

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
  String placeholder = '...',
}) {
  var chunks = splitChunks(text,
      breakOnHyphens: breakLongWords,
      expandTabs: expandTabs,
      tabSize: tabSize,
      replaceWhitespace: replaceWhitespace);

  if (fixSentenceEndings) {
    fixEndings(chunks);
  }

  return wrapChunks(chunks,
      width: width,
      initialIndent: initialIndent,
      subsequentIndent: subsequentIndent,
      breakLongWords: breakLongWords,
      dropWhitespace: dropWhitespace,
      breakOnHyphens: breakOnHyphens,
      maxLines: maxLines,
      placeholder: placeholder);
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
  String placeholder = '...',
}) {
  return wrap(text,
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
          placeholder: placeholder)
      .join('\n');
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
  return fill(text.split(spaceRe).join(' '),
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
      placeholder: placeholder);
}

class TextWrapper {
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

  /// Reformat the single paragraph in [text] so it fits in lines of no more
  /// than [width] columns, and return a list of wrapped lines.
  List<String> wrap(String text) {
    var chunks = splitChunks(text,
        breakOnHyphens: breakLongWords,
        expandTabs: expandTabs,
        tabSize: tabSize,
        replaceWhitespace: replaceWhitespace);

    if (fixSentenceEndings) {
      fixEndings(chunks);
    }

    return wrapChunks(chunks,
        width: width,
        initialIndent: initialIndent,
        subsequentIndent: subsequentIndent,
        breakLongWords: breakLongWords,
        dropWhitespace: dropWhitespace,
        breakOnHyphens: breakOnHyphens,
        maxLines: maxLines,
        placeholder: placeholder);
  }

  /// Reformat the single paragraph in [text] to fit in lines of no more than
  /// [width] columns, and return a new string containing the entire wrapped
  /// ßparagraph.
  String fill(String text) {
    return wrap(text).join('\n');
  }
}
