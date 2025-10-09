// ignore_for_file: non_constant_identifier_names

import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:textwrap/textwrap.dart';

import 'base_test_case.dart';

@reflectiveTest
final class LongWordTestCase extends BaseTestCase {
  final text = '''
Did you say "supercalifragilisticexpialidocious?"
How *do* you spell that odd word, anyways?
''';

  void setUp() {
    wrapper = TextWrapper();
  }

  void test_break_long() {
    checkWrap(text, 30, [
      'Did you say "supercalifragilis',
      'ticexpialidocious?" How *do*',
      'you spell that odd word,',
      'anyways?',
    ]);
    checkWrap(text, 50, [
      'Did you say "supercalifragilisticexpialidocious?"',
      'How *do* you spell that odd word, anyways?',
    ]);

    checkWrap('${'-' * 10}hello', 10, [
      '----------',
      '               h',
      '               e',
      '               l',
      '               l',
      '               o',
    ], subsequentIndent: ' ' * 15);

    checkWrap(text, 12, [
      'Did you say ',
      '"supercalifr',
      'agilisticexp',
      'ialidocious?',
      '" How *do*',
      'you spell',
      'that odd',
      'word,',
      'anyways?',
    ]);
  }

  void test_nobreak_long() {
    var wrapper = TextWrapper(breakLongWords: false, width: 30);
    var expected = [
      'Did you say',
      '"supercalifragilisticexpialidocious?"',
      'How *do* you spell that odd',
      'word, anyways?',
    ];
    var result = wrapper.wrap(text);
    expect(result, expected);

    var result2 = wrap(text, width: 30, breakLongWords: false);
    expect(result2, expected);
  }

  void test_max_lines_long() {
    checkWrap(text, 12, [
      'Did you say ',
      '"supercalifr',
      'agilisticexp',
      '[...]',
    ], maxLines: 4);
  }
}
