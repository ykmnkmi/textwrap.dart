import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

void main() {
  group('WrapTestCase', () {
    void checkSplit(String text, List<String> expected) {
      var wrapper = TextWrapper(width: 45);
      var result = wrapper.split(wrapper.mungeWhitespace(text));
      expect(result, equals(expected));
    }

    test('simple', () {
      var text =
          "Hello there, how are you this fine day?  I'm glad to hear it!";

      expect(
        wrap(text, width: 12),
        equals(<String>[
          'Hello there,',
          'how are you',
          'this fine',
          "day?  I'm",
          'glad to hear',
          'it!',
        ]),
      );

      expect(
        wrap(text, width: 42),
        equals(<String>[
          'Hello there, how are you this fine day?',
          "I'm glad to hear it!",
        ]),
      );

      expect(wrap(text, width: 80), equals(<String>[text]));
    });

    test('empty string', () {
      expect(wrap('', width: 6), isEmpty);
      expect(wrap('', width: 6, dropWhitespace: false), isEmpty);
    });

    test('empty string with initial indent', () {
      expect(wrap('', width: 6, initialIndent: '++'), isEmpty);

      expect(
        wrap('', width: 6, initialIndent: '++', dropWhitespace: false),
        isEmpty,
      );
    });

    test('whitespace', () {
      var text = '''
This is a paragraph that already has
line breaks.  But some of its lines are much longer than the others,
so it needs to be wrapped.
Some lines are \ttabbed too.
What a mess!
''';

      var expected = <String>[
        'This is a paragraph that already has line',
        'breaks.  But some of its lines are much',
        'longer than the others, so it needs to be',
        'wrapped.  Some lines are  tabbed too.  What a',
        'mess!',
      ];

      var wrapper = TextWrapper(width: 45, fixSentenceEndings: true);
      var result = wrapper.wrap(text);
      expect(result, equals(expected));

      var fillResult = wrapper.fill(text);
      expect(fillResult, equals(expected.join('\n')));

      expect(
        wrap('\tTest\tdefault\t\ttabsize.', width: 80),
        equals(<String>['        Test    default         tabsize.']),
      );

      expect(
        wrap('\tTest\tcustom\t\ttabsize.', width: 80, tabSize: 4),
        equals(<String>['    Test    custom      tabsize.']),
      );
    });

    test('fix sentence endings', () {
      var wrapper = TextWrapper(width: 60, fixSentenceEndings: true);

      var text = 'A short line. Note the single space.';
      var expected = <String>['A short line.  Note the single space.'];
      expect(wrapper.wrap(text), equals(expected));

      text = 'Well, Doctor? What do you think?';
      expected = <String>['Well, Doctor?  What do you think?'];
      expect(wrapper.wrap(text), equals(expected));

      text = 'Well, Doctor?\nWhat do you think?';
      expect(wrapper.wrap(text), equals(expected));

      text = 'I say, chaps! Anyone for "tennis?"\nHmmph!';
      expected = <String>['I say, chaps!  Anyone for "tennis?"  Hmmph!'];
      expect(wrapper.wrap(text), equals(expected));

      wrapper = TextWrapper(width: 20, fixSentenceEndings: true);
      expected = <String>['I say, chaps!', 'Anyone for "tennis?"', 'Hmmph!'];
      expect(wrapper.wrap(text), equals(expected));

      text = 'And she said, "Go to hell!"\nCan you believe that?';

      expected = <String>[
        'And she said, "Go to',
        'hell!"  Can you',
        'believe that?',
      ];

      expect(wrapper.wrap(text), equals(expected));

      wrapper = TextWrapper(width: 60, fixSentenceEndings: true);
      expected = <String>['And she said, "Go to hell!"  Can you believe that?'];
      expect(wrapper.wrap(text), equals(expected));

      text = 'File stdio.h is nice.';
      expected = <String>['File stdio.h is nice.'];
      expect(wrapper.wrap(text), equals(expected));
    });

    test('wrap short', () {
      var text = 'This is a\nshort paragraph.';

      expect(
        wrap(text, width: 20),
        equals(<String>['This is a short', 'paragraph.']),
      );

      expect(
        wrap(text, width: 40),
        equals(<String>['This is a short paragraph.']),
      );
    });

    test('wrap short 1line', () {
      var text = 'This is a short line.';

      expect(wrap(text, width: 30), equals(<String>['This is a short line.']));

      expect(
        wrap(text, width: 30, initialIndent: '(1) '),
        equals(<String>['(1) This is a short line.']),
      );
    });

    test('hyphenated', () {
      var text =
          'this-is-a-useful-feature-for-'
          "reformatting-posts-from-tim-peters'ly";

      expect(
        wrap(text, width: 40),
        equals(<String>[
          'this-is-a-useful-feature-for-',
          "reformatting-posts-from-tim-peters'ly",
        ]),
      );

      expect(
        wrap(text, width: 41),
        equals(<String>[
          'this-is-a-useful-feature-for-',
          "reformatting-posts-from-tim-peters'ly",
        ]),
      );

      expect(
        wrap(text, width: 42),
        equals(<String>[
          'this-is-a-useful-feature-for-reformatting-',
          "posts-from-tim-peters'ly",
        ]),
      );

      var expected =
          'this-|is-|a-|useful-|feature-|for-|'
                  "reformatting-|posts-|from-|tim-|peters'ly"
              .split('|');

      expect(wrap(text, width: 1, breakLongWords: false), equals(expected));
      checkSplit(text, expected);

      checkSplit('e-mail', <String>['e-mail']);
      checkSplit('Jelly-O', <String>['Jelly-O']);
      checkSplit('half-a-crown', 'half-|a-|crown'.split('|'));
    });

    test('hyphenated numbers', () {
      var text =
          'Python 1.0.0 was released on 1994-01-26.  Python 1.0.1 was\n'
          'released on 1994-02-15.';

      expect(
        wrap(text, width: 30),
        equals(<String>[
          'Python 1.0.0 was released on',
          '1994-01-26.  Python 1.0.1 was',
          'released on 1994-02-15.',
        ]),
      );

      expect(
        wrap(text, width: 40),
        equals(<String>[
          'Python 1.0.0 was released on 1994-01-26.',
          'Python 1.0.1 was released on 1994-02-15.',
        ]),
      );

      expect(
        wrap(text, width: 1, breakLongWords: false),
        equals(text.split(RegExp(r'\s+'))),
      );

      text = 'I do all my shopping at 7-11.';

      expect(
        wrap(text, width: 25),
        equals(<String>['I do all my shopping at', '7-11.']),
      );

      expect(
        wrap(text, width: 27),
        equals(<String>['I do all my shopping at', '7-11.']),
      );

      expect(
        wrap(text, width: 29),
        equals(<String>['I do all my shopping at 7-11.']),
      );

      expect(
        wrap(text, width: 1, breakLongWords: false),
        equals(text.split(RegExp(r'\s+'))),
      );
    });

    test('em dash', () {
      var text = 'Em-dashes should be written -- thus.';

      expect(
        wrap(text, width: 25),
        equals(<String>['Em-dashes should be', 'written -- thus.']),
      );

      expect(
        wrap(text, width: 29),
        equals(<String>['Em-dashes should be written', '-- thus.']),
      );

      var expected = <String>['Em-dashes should be written --', 'thus.'];
      expect(wrap(text, width: 30), equals(expected));
      expect(wrap(text, width: 35), equals(expected));

      expect(
        wrap(text, width: 36),
        equals(<String>['Em-dashes should be written -- thus.']),
      );

      text = 'You can also do--this or even---this.';
      expected = <String>['You can also do', '--this or even', '---this.'];
      expect(wrap(text, width: 15), equals(expected));
      expect(wrap(text, width: 16), equals(expected));
      expected = <String>['You can also do--', 'this or even---', 'this.'];
      expect(wrap(text, width: 17), equals(expected));
      expect(wrap(text, width: 19), equals(expected));
      expected = <String>['You can also do--this or even', '---this.'];
      expect(wrap(text, width: 29), equals(expected));
      expect(wrap(text, width: 31), equals(expected));
      expected = <String>['You can also do--this or even---', 'this.'];
      expect(wrap(text, width: 32), equals(expected));
      expect(wrap(text, width: 35), equals(expected));

      text = "Here's an -- em-dash and--here's another---and another!";

      expected = <String>[
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

      expected = <String>[
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
    });

    test('unix options', () {
      var text = 'You should use the -n option, or --dry-run in its long form.';

      expect(
        wrap(text, width: 20),
        equals(<String>[
          'You should use the',
          '-n option, or --dry-',
          'run in its long',
          'form.',
        ]),
      );

      expect(
        wrap(text, width: 21),
        equals(<String>[
          'You should use the -n',
          'option, or --dry-run',
          'in its long form.',
        ]),
      );

      var expected = <String>[
        'You should use the -n option, or',
        '--dry-run in its long form.',
      ];

      expect(wrap(text, width: 32), equals(expected));
      expect(wrap(text, width: 34), equals(expected));
      expect(wrap(text, width: 35), equals(expected));
      expect(wrap(text, width: 38), equals(expected));

      expected = <String>[
        'You should use the -n option, or --dry-',
        'run in its long form.',
      ];

      expect(wrap(text, width: 39), equals(expected));
      expect(wrap(text, width: 41), equals(expected));

      expected = <String>[
        'You should use the -n option, or --dry-run',
        'in its long form.',
      ];

      expect(wrap(text, width: 42), equals(expected));

      text = 'the -n option, or --dry-run or --dryrun';

      expected = <String>[
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
      checkSplit(text, expected);
    });

    test('funky hyphens', () {
      checkSplit('what the--hey!', <String>['what', ' ', 'the', '--', 'hey!']);
      checkSplit('what the--', <String>['what', ' ', 'the--']);
      checkSplit('what the--.', <String>['what', ' ', 'the--.']);
      checkSplit('--text--.', <String>['--text--.']);

      checkSplit('--option', <String>['--option']);
      checkSplit('--option-opt', <String>['--option-', 'opt']);

      checkSplit('foo --option-opt bar', <String>[
        'foo',
        ' ',
        '--option-',
        'opt',
        ' ',
        'bar',
      ]);
    });

    test('punct hyphens', () {
      checkSplit("the 'wibble-wobble' widget", <String>[
        'the',
        ' ',
        "'wibble-",
        "wobble'",
        ' ',
        'widget',
      ]);

      checkSplit('the "wibble-wobble" widget', <String>[
        'the',
        ' ',
        '"wibble-',
        'wobble"',
        ' ',
        'widget',
      ]);

      checkSplit('the (wibble-wobble) widget', <String>[
        'the',
        ' ',
        '(wibble-',
        'wobble)',
        ' ',
        'widget',
      ]);

      checkSplit("the ['wibble-wobble'] widget", <String>[
        'the',
        ' ',
        "['wibble-",
        "wobble']",
        ' ',
        'widget',
      ]);

      checkSplit("what-d'you-call-it.", "what-d'you-|call-|it.".split('|'));
    });

    test('funky parens', () {
      checkSplit('foo (--option) bar', <String>[
        'foo',
        ' ',
        '(--option)',
        ' ',
        'bar',
      ]);

      checkSplit('foo (bar) baz', <String>['foo', ' ', '(bar)', ' ', 'baz']);

      checkSplit('blah (ding dong), wubba', <String>[
        'blah',
        ' ',
        '(ding',
        ' ',
        'dong),',
        ' ',
        'wubba',
      ]);
    });

    test('drop whitespace false', () {
      var text = ' This is a    sentence with     much whitespace.';

      expect(
        wrap(text, width: 10, dropWhitespace: false),
        equals(<String>[
          ' This is a',
          '    ',
          'sentence ',
          'with     ',
          'much white',
          'space.',
        ]),
      );
    });

    test('drop whitespace false whitespace only', () {
      expect(
        wrap('   ', width: 6, dropWhitespace: false),
        equals(<String>['   ']),
      );
    });

    test('drop whitespace false whitespace only with indent', () {
      expect(
        wrap('   ', width: 6, dropWhitespace: false, initialIndent: '  '),
        equals(<String>['     ']),
      );
    });

    test('drop whitespace whitespace only', () {
      expect(wrap('  ', width: 6), equals(isEmpty));
    });

    test('drop whitespace leading whitespace', () {
      var text = ' This is a sentence with leading whitespace.';

      expect(
        wrap(text, width: 50),
        equals(<String>[' This is a sentence with leading whitespace.']),
      );

      expect(
        wrap(text, width: 30),
        equals(<String>[' This is a sentence with', 'leading whitespace.']),
      );
    });

    test('drop whitespace whitespace line', () {
      var text = 'abcd    efgh';

      expect(
        wrap(text, width: 6, dropWhitespace: false),
        equals(<String>['abcd', '    ', 'efgh']),
      );

      expect(wrap(text, width: 6), equals(<String>['abcd', 'efgh']));
    });

    test('drop whitespace whitespace only with indent', () {
      expect(wrap('  ', width: 6, initialIndent: '++'), equals(isEmpty));
    });

    test('drop whitespace whitespace indent', () {
      expect(
        wrap(
          'abcd efgh',
          width: 6,
          initialIndent: '  ',
          subsequentIndent: '  ',
        ),
        equals(<String>['  abcd', '  efgh']),
      );
    });

    test('split', () {
      var text = 'Hello there -- you goof-ball, use the -b option!';

      var wrapper = TextWrapper(width: 45);
      var result = wrapper.split(wrapper.mungeWhitespace(text));

      expect(
        result,
        equals(<String>[
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
        ]),
      );
    });

    test('break on hyphens', () {
      var text = 'yaba daba-doo';

      expect(
        wrap(text, width: 10, breakOnHyphens: true),
        equals(<String>['yaba daba-', 'doo']),
      );

      expect(
        wrap(text, width: 10, breakOnHyphens: false),
        equals(<String>['yaba', 'daba-doo']),
      );
    });

    test('bad width', () {
      var text = "Whatever, it doesn't matter.";
      expect(() => wrap(text, width: 0), throwsArgumentError);
      expect(() => wrap(text, width: -1), throwsArgumentError);
    });

    test('no split at umlaut', () {
      var text = 'Die EmpfÃ¤nger-Auswahl';
      expect(
        wrap(text, width: 13),
        equals(<String>['Die', 'EmpfÃ¤nger-', 'Auswahl']),
      );
    });

    test('umlaut followed by dash', () {
      var text = 'aa ää-ää';
      expect(wrap(text, width: 7), equals(<String>['aa ää-', 'ää']));
    });

    test('non breaking space', () {
      var text = 'This is a sentence with non-breaking\u00A0space.';

      expect(
        wrap(text, width: 20, breakOnHyphens: true),
        equals(<String>[
          'This is a sentence',
          'with non-',
          'breaking\u00A0space.',
        ]),
      );

      expect(
        wrap(text, width: 20, breakOnHyphens: false),
        equals(<String>[
          'This is a sentence',
          'with',
          'non-breaking\u00A0space.',
        ]),
      );
    });

    test('narrow non breaking space', () {
      var text = 'This is a sentence with non-breaking\u202Fspace.';

      expect(
        wrap(text, width: 20, breakOnHyphens: true),
        equals(<String>[
          'This is a sentence',
          'with non-',
          'breaking\u202Fspace.',
        ]),
      );

      expect(
        wrap(text, width: 20, breakOnHyphens: false),
        equals(<String>[
          'This is a sentence',
          'with',
          'non-breaking\u202Fspace.',
        ]),
      );
    });
  });
}
