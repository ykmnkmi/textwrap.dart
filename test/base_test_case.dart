import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

/// Parent class with utility methods for textwrap tests.
abstract base class BaseTestCase {
  late TextWrapper wrapper;

  void checkWrap(
    String text,
    int width,
    List<String> expected, {
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
    String placeholder = ' [...]',
  }) {
    var result = wrap(
      text,
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
    );
    expect(result, expected);
  }

  void checkSplit(String text, List<String> expected) {
    var result = wrapper.split(wrapper.mungeWhitespace(text));
    expect(result, expected);
  }
}
