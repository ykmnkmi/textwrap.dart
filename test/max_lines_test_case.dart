// ignore_for_file: non_constant_identifier_names

import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:textwrap/textwrap.dart';

import 'base_test_case.dart';

@reflectiveTest
final class MaxLinesTestCase extends BaseTestCase {
  final text = "Hello there, how are you this fine day?  I'm glad to hear it!";

  void test_simple() {
    checkWrap(text, 12, ['Hello [...]'], maxLines: 0);
    checkWrap(text, 12, ['Hello [...]'], maxLines: 1);
    checkWrap(text, 12, ['Hello there,', 'how [...]'], maxLines: 2);
    checkWrap(text, 13, ['Hello there,', 'how are [...]'], maxLines: 2);
    checkWrap(text, 80, [text], maxLines: 1);
    checkWrap(text, 12, [
      'Hello there,',
      'how are you',
      'this fine',
      "day?  I'm",
      'glad to hear',
      'it!',
    ], maxLines: 6);
  }

  void test_spaces() {
    checkWrap(text, 12, [
      'Hello there,',
      'how are you',
      'this fine',
      'day? [...]',
    ], maxLines: 4);

    checkWrap(text, 6, ['Hello', '[...]'], maxLines: 2);

    checkWrap('$text          ', 12, [
      'Hello there,',
      'how are you',
      'this fine',
      "day?  I'm",
      'glad to hear',
      'it!',
    ], maxLines: 6);
  }

  void test_placeholder() {
    checkWrap(text, 12, ['Hello...'], maxLines: 1, placeholder: '...');
    checkWrap(
      text,
      12,
      ['Hello there,', 'how are...'],
      maxLines: 2,
      placeholder: '...',
    );

    expect(
      () => wrap(
        text,
        width: 16,
        initialIndent: '    ',
        maxLines: 1,
        placeholder: ' [truncated]...',
      ),
      throwsStateError,
    );
    expect(
      () => wrap(
        text,
        width: 16,
        subsequentIndent: '    ',
        maxLines: 2,
        placeholder: ' [truncated]...',
      ),
      throwsStateError,
    );

    checkWrap(
      text,
      16,
      ['    Hello there,', '  [truncated]...'],
      maxLines: 2,
      initialIndent: '    ',
      subsequentIndent: '  ',
      placeholder: ' [truncated]...',
    );

    checkWrap(
      text,
      16,
      ['  [truncated]...'],
      maxLines: 1,
      initialIndent: '  ',
      subsequentIndent: '    ',
      placeholder: ' [truncated]...',
    );

    checkWrap(text, 80, [text], placeholder: '.' * 1000);
  }

  void test_placeholder_backtrack() {
    var text = 'Good grief Python features are advancing quickly!';
    checkWrap(
      text,
      12,
      ['Good grief', 'Python*****'],
      maxLines: 3,
      placeholder: '*****',
    );
  }
}
