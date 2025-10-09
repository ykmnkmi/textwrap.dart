// ignore_for_file: non_constant_identifier_names

import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:textwrap/textwrap.dart';

import 'base_test_case.dart';

@reflectiveTest
final class WrapTestCase extends BaseTestCase {
  void setUp() {
    wrapper = TextWrapper(width: 45);
  }

  void test_simple() {
    var text = "Hello there, how are you this fine day?  I'm glad to hear it!";

    checkWrap(text, 12, [
      'Hello there,',
      'how are you',
      'this fine',
      "day?  I'm",
      'glad to hear',
      'it!',
    ]);
    checkWrap(text, 42, [
      'Hello there, how are you this fine day?',
      "I'm glad to hear it!",
    ]);
    checkWrap(text, 80, [text]);
  }

  void test_empty_string() {
    checkWrap('', 6, []);
    checkWrap('', 6, [], dropWhitespace: false);
  }

  void test_empty_string_with_initial_indent() {
    checkWrap('', 6, [], initialIndent: '++');
    checkWrap('', 6, [], initialIndent: '++', dropWhitespace: false);
  }

  void test_whitespace() {
    var text = '''
This is a paragraph that already has
line breaks.  But some of its lines are much longer than the others,
so it needs to be wrapped.
Some lines are \ttabbed too.
What a mess!
''';

    var expected = [
      'This is a paragraph that already has line',
      'breaks.  But some of its lines are much',
      'longer than the others, so it needs to be',
      'wrapped.  Some lines are  tabbed too.  What a',
      'mess!',
    ];

    var wrapper = TextWrapper(width: 45, fixSentenceEndings: true);
    var result = wrapper.wrap(text);
    expect(result, expected);

    var fillResult = wrapper.fill(text);
    expect(fillResult, expected.join('\n'));

    checkWrap('\tTest\tdefault\t\ttabsize.', 80, [
      '        Test    default         tabsize.',
    ]);

    checkWrap('\tTest\tcustom\t\ttabsize.', 80, [
      '    Test    custom      tabsize.',
    ], tabSize: 4);
  }

  void test_fix_sentence_endings() {
    var wrapper = TextWrapper(width: 60, fixSentenceEndings: true);

    var text = 'A short line. Note the single space.';
    var expected = ['A short line.  Note the single space.'];
    expect(wrapper.wrap(text), expected);

    text = 'Well, Doctor? What do you think?';
    expected = ['Well, Doctor?  What do you think?'];
    expect(wrapper.wrap(text), expected);

    text = 'Well, Doctor?\nWhat do you think?';
    expect(wrapper.wrap(text), expected);

    text = 'I say, chaps! Anyone for "tennis?"\nHmmph!';
    expected = ['I say, chaps!  Anyone for "tennis?"  Hmmph!'];
    expect(wrapper.wrap(text), expected);

    var wrapper2 = TextWrapper(width: 20, fixSentenceEndings: true);
    expected = ['I say, chaps!', 'Anyone for "tennis?"', 'Hmmph!'];
    expect(wrapper2.wrap(text), expected);

    text = 'And she said, "Go to hell!"\nCan you believe that?';
    expected = ['And she said, "Go to', 'hell!"  Can you', 'believe that?'];
    expect(wrapper2.wrap(text), expected);

    var wrapper3 = TextWrapper(width: 60, fixSentenceEndings: true);
    expected = ['And she said, "Go to hell!"  Can you believe that?'];
    expect(wrapper3.wrap(text), expected);

    text = 'File stdio.h is nice.';
    expected = ['File stdio.h is nice.'];
    expect(wrapper3.wrap(text), expected);
  }

  void test_wrap_short() {
    var text = 'This is a\nshort paragraph.';

    checkWrap(text, 20, ['This is a short', 'paragraph.']);
    checkWrap(text, 40, ['This is a short paragraph.']);
  }

  void test_wrap_short_1line() {
    var text = 'This is a short line.';

    checkWrap(text, 30, ['This is a short line.']);
    checkWrap(text, 30, ['(1) This is a short line.'], initialIndent: '(1) ');
  }

  void test_hyphenated() {
    var text =
        'this-is-a-useful-feature-for-'
        "reformatting-posts-from-tim-peters'ly";

    checkWrap(text, 40, [
      'this-is-a-useful-feature-for-',
      "reformatting-posts-from-tim-peters'ly",
    ]);
    checkWrap(text, 41, [
      'this-is-a-useful-feature-for-',
      "reformatting-posts-from-tim-peters'ly",
    ]);
    checkWrap(text, 42, [
      'this-is-a-useful-feature-for-reformatting-',
      "posts-from-tim-peters'ly",
    ]);

    var expected =
        'this-|is-|a-|useful-|feature-|for-|'
                "reformatting-|posts-|from-|tim-|peters'ly"
            .split('|');
    checkWrap(text, 1, expected, breakLongWords: false);
    checkSplit(text, expected);

    checkSplit('e-mail', ['e-mail']);
    checkSplit('Jelly-O', ['Jelly-O']);
    checkSplit('half-a-crown', 'half-|a-|crown'.split('|'));
  }

  void test_hyphenated_numbers() {
    var text =
        'Python 1.0.0 was released on 1994-01-26.  Python 1.0.1 was\n'
        'released on 1994-02-15.';

    checkWrap(text, 30, [
      'Python 1.0.0 was released on',
      '1994-01-26.  Python 1.0.1 was',
      'released on 1994-02-15.',
    ]);
    checkWrap(text, 40, [
      'Python 1.0.0 was released on 1994-01-26.',
      'Python 1.0.1 was released on 1994-02-15.',
    ]);
    checkWrap(text, 1, text.split(RegExp(r'\s+')), breakLongWords: false);

    text = 'I do all my shopping at 7-11.';
    checkWrap(text, 25, ['I do all my shopping at', '7-11.']);
    checkWrap(text, 27, ['I do all my shopping at', '7-11.']);
    checkWrap(text, 29, ['I do all my shopping at 7-11.']);
    checkWrap(text, 1, text.split(RegExp(r'\s+')), breakLongWords: false);
  }

  void test_em_dash() {
    var text = 'Em-dashes should be written -- thus.';
    checkWrap(text, 25, ['Em-dashes should be', 'written -- thus.']);

    checkWrap(text, 29, ['Em-dashes should be written', '-- thus.']);
    var expected = ['Em-dashes should be written --', 'thus.'];
    checkWrap(text, 30, expected);
    checkWrap(text, 35, expected);
    checkWrap(text, 36, ['Em-dashes should be written -- thus.']);

    text = 'You can also do--this or even---this.';
    expected = ['You can also do', '--this or even', '---this.'];
    checkWrap(text, 15, expected);
    checkWrap(text, 16, expected);
    expected = ['You can also do--', 'this or even---', 'this.'];
    checkWrap(text, 17, expected);
    checkWrap(text, 19, expected);
    expected = ['You can also do--this or even', '---this.'];
    checkWrap(text, 29, expected);
    checkWrap(text, 31, expected);
    expected = ['You can also do--this or even---', 'this.'];
    checkWrap(text, 32, expected);
    checkWrap(text, 35, expected);

    text = "Here's an -- em-dash and--here's another---and another!";
    expected = [
      "Here's",
      ' ',
      'an',
      ' ',
      '--',
      ' ',
      'em-',
      'dash',
      ' ',
      'and',
      '--',
      "here's",
      ' ',
      'another',
      '---',
      'and',
      ' ',
      'another!',
    ];
    checkSplit(text, expected);

    text = 'and then--bam!--he was gone';
    expected = [
      'and',
      ' ',
      'then',
      '--',
      'bam!',
      '--',
      'he',
      ' ',
      'was',
      ' ',
      'gone',
    ];
    checkSplit(text, expected);
  }

  void test_unix_options() {
    var text = 'You should use the -n option, or --dry-run in its long form.';
    checkWrap(text, 20, [
      'You should use the',
      '-n option, or --dry-',
      'run in its long',
      'form.',
    ]);
    checkWrap(text, 21, [
      'You should use the -n',
      'option, or --dry-run',
      'in its long form.',
    ]);
    var expected = [
      'You should use the -n option, or',
      '--dry-run in its long form.',
    ];
    checkWrap(text, 32, expected);
    checkWrap(text, 34, expected);
    checkWrap(text, 35, expected);
    checkWrap(text, 38, expected);
    expected = [
      'You should use the -n option, or --dry-',
      'run in its long form.',
    ];
    checkWrap(text, 39, expected);
    checkWrap(text, 41, expected);
    expected = [
      'You should use the -n option, or --dry-run',
      'in its long form.',
    ];
    checkWrap(text, 42, expected);

    var text2 = 'the -n option, or --dry-run or --dryrun';
    var expected2 = [
      'the',
      ' ',
      '-n',
      ' ',
      'option,',
      ' ',
      'or',
      ' ',
      '--dry-',
      'run',
      ' ',
      'or',
      ' ',
      '--dryrun',
    ];
    checkSplit(text2, expected2);
  }

  void test_funky_hyphens() {
    checkSplit('what the--hey!', ['what', ' ', 'the', '--', 'hey!']);
    checkSplit('what the--', ['what', ' ', 'the--']);
    checkSplit('what the--.', ['what', ' ', 'the--.']);
    checkSplit('--text--.', ['--text--.']);

    checkSplit('--option', ['--option']);
    checkSplit('--option-opt', ['--option-', 'opt']);
    checkSplit('foo --option-opt bar', [
      'foo',
      ' ',
      '--option-',
      'opt',
      ' ',
      'bar',
    ]);
  }

  void test_punct_hyphens() {
    checkSplit("the 'wibble-wobble' widget", [
      'the',
      ' ',
      "'wibble-",
      "wobble'",
      ' ',
      'widget',
    ]);
    checkSplit('the "wibble-wobble" widget', [
      'the',
      ' ',
      '"wibble-',
      'wobble"',
      ' ',
      'widget',
    ]);
    checkSplit('the (wibble-wobble) widget', [
      'the',
      ' ',
      '(wibble-',
      'wobble)',
      ' ',
      'widget',
    ]);
    checkSplit("the ['wibble-wobble'] widget", [
      'the',
      ' ',
      "['wibble-",
      "wobble']",
      ' ',
      'widget',
    ]);

    checkSplit("what-d'you-call-it.", "what-d'you-|call-|it.".split('|'));
  }

  void test_funky_parens() {
    checkSplit('foo (--option) bar', ['foo', ' ', '(--option)', ' ', 'bar']);

    checkSplit('foo (bar) baz', ['foo', ' ', '(bar)', ' ', 'baz']);
    checkSplit('blah (ding dong), wubba', [
      'blah',
      ' ',
      '(ding',
      ' ',
      'dong),',
      ' ',
      'wubba',
    ]);
  }

  void test_drop_whitespace_false() {
    var text = ' This is a    sentence with     much whitespace.';
    checkWrap(text, 10, [
      ' This is a',
      '    ',
      'sentence ',
      'with     ',
      'much white',
      'space.',
    ], dropWhitespace: false);
  }

  void test_drop_whitespace_false_whitespace_only() {
    checkWrap('   ', 6, ['   '], dropWhitespace: false);
  }

  void test_drop_whitespace_false_whitespace_only_with_indent() {
    checkWrap('   ', 6, ['     '], dropWhitespace: false, initialIndent: '  ');
  }

  void test_drop_whitespace_whitespace_only() {
    checkWrap('  ', 6, []);
  }

  void test_drop_whitespace_leading_whitespace() {
    var text = ' This is a sentence with leading whitespace.';
    checkWrap(text, 50, [' This is a sentence with leading whitespace.']);
    checkWrap(text, 30, [' This is a sentence with', 'leading whitespace.']);
  }

  void test_drop_whitespace_whitespace_line() {
    var text = 'abcd    efgh';
    checkWrap(text, 6, ['abcd', '    ', 'efgh'], dropWhitespace: false);
    checkWrap(text, 6, ['abcd', 'efgh']);
  }

  void test_drop_whitespace_whitespace_only_with_indent() {
    checkWrap('  ', 6, [], initialIndent: '++');
  }

  void test_drop_whitespace_whitespace_indent() {
    checkWrap(
      'abcd efgh',
      6,
      ['  abcd', '  efgh'],
      initialIndent: '  ',
      subsequentIndent: '  ',
    );
  }

  void test_split() {
    var text = 'Hello there -- you goof-ball, use the -b option!';
    var result = wrapper.split(wrapper.mungeWhitespace(text));
    expect(result, [
      'Hello',
      ' ',
      'there',
      ' ',
      '--',
      ' ',
      'you',
      ' ',
      'goof-',
      'ball,',
      ' ',
      'use',
      ' ',
      'the',
      ' ',
      '-b',
      ' ',
      'option!',
    ]);
  }

  void test_break_on_hyphens() {
    var text = 'yaba daba-doo';
    checkWrap(text, 10, ['yaba daba-', 'doo'], breakOnHyphens: true);
    checkWrap(text, 10, ['yaba', 'daba-doo'], breakOnHyphens: false);
  }

  void test_bad_width() {
    var text = "Whatever, it doesn't matter.";
    expect(() => wrap(text, width: 0), throwsArgumentError);
    expect(() => wrap(text, width: -1), throwsArgumentError);
  }

  void test_no_split_at_umlaut() {
    var text = 'Die Empfänger-Auswahl';
    checkWrap(text, 13, ['Die', 'Empfänger-', 'Auswahl']);
  }

  void test_umlaut_followed_by_dash() {
    var text = 'aa ää-ää';
    checkWrap(text, 7, ['aa ää-', 'ää']);
  }

  void test_non_breaking_space() {
    var text = 'This is a sentence with non-breaking\u00A0space.';

    checkWrap(text, 20, [
      'This is a sentence',
      'with non-',
      'breaking\u00A0space.',
    ], breakOnHyphens: true);

    checkWrap(text, 20, [
      'This is a sentence',
      'with',
      'non-breaking\u00A0space.',
    ], breakOnHyphens: false);
  }

  void test_narrow_non_breaking_space() {
    var text = 'This is a sentence with non-breaking\u202Fspace.';

    checkWrap(text, 20, [
      'This is a sentence',
      'with non-',
      'breaking\u202Fspace.',
    ], breakOnHyphens: true);

    checkWrap(text, 20, [
      'This is a sentence',
      'with',
      'non-breaking\u202Fspace.',
    ], breakOnHyphens: false);
  }
}
