// ignore_for_file: non_constant_identifier_names

import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:textwrap/textwrap.dart';

import 'base_test_case.dart';

@reflectiveTest
final class LongWordWithHyphensTestCase extends BaseTestCase {
  final text1 = '''
We used enyzme 2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate synthase.
''';
  final text2 = '''
1234567890-1234567890--this_is_a_very_long_option_indeed-good-bye"
''';

  void setUp() {
    wrapper = TextWrapper();
  }

  void test_break_long_words_on_hyphen() {
    checkWrap(text1, 50, [
      'We used enyzme 2-succinyl-6-hydroxy-2,4-',
      'cyclohexadiene-1-carboxylate synthase.',
    ]);

    checkWrap(text1, 10, [
      'We used',
      'enyzme 2-',
      'succinyl-',
      '6-hydroxy-',
      '2,4-',
      'cyclohexad',
      'iene-1-',
      'carboxylat',
      'e',
      'synthase.',
    ]);

    checkWrap(text2, 10, [
      '1234567890',
      '-123456789',
      '0--this_is',
      '_a_very_lo',
      'ng_option_',
      'indeed-',
      'good-bye"',
    ]);
  }

  void test_break_long_words_not_on_hyphen() {
    checkWrap(text1, 50, [
      'We used enyzme 2-succinyl-6-hydroxy-2,4-cyclohexad',
      'iene-1-carboxylate synthase.',
    ], breakOnHyphens: false);

    checkWrap(text1, 10, [
      'We used',
      'enyzme 2-s',
      'uccinyl-6-',
      'hydroxy-2,',
      '4-cyclohex',
      'adiene-1-c',
      'arboxylate',
      'synthase.',
    ], breakOnHyphens: false);

    checkWrap(text2, 10, [
      '1234567890',
      '-123456789',
      '0--this_is',
      '_a_very_lo',
      'ng_option_',
      'indeed-',
      'good-bye"',
    ]);
  }

  void test_break_on_hyphen_but_not_long_words() {
    checkWrap(text1, 50, [
      'We used enyzme',
      '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
      'synthase.',
    ], breakLongWords: false);

    checkWrap(text1, 10, [
      'We used',
      'enyzme',
      '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
      'synthase.',
    ], breakLongWords: false);

    checkWrap(text2, 10, [
      '1234567890',
      '-123456789',
      '0--this_is',
      '_a_very_lo',
      'ng_option_',
      'indeed-',
      'good-bye"',
    ]);
  }

  void test_do_not_break_long_words_or_on_hyphens() {
    checkWrap(
      text1,
      50,
      [
        'We used enyzme',
        '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
        'synthase.',
      ],
      breakLongWords: false,
      breakOnHyphens: false,
    );

    checkWrap(
      text1,
      10,
      [
        'We used',
        'enyzme',
        '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
        'synthase.',
      ],
      breakLongWords: false,
      breakOnHyphens: false,
    );

    checkWrap(text2, 10, [
      '1234567890',
      '-123456789',
      '0--this_is',
      '_a_very_lo',
      'ng_option_',
      'indeed-',
      'good-bye"',
    ]);
  }
}
