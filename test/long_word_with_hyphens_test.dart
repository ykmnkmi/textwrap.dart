import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

void main() {
  group('LongWordWithHyphensTestCase', () {
    var text1 = '''
We used enyzme 2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate synthase.
''';
    var text2 = '''
1234567890-1234567890--this_is_a_very_long_option_indeed-good-bye"
''';

    test('break long words on hyphen', () {
      expect(
        wrap(text1, width: 50),
        equals(<String>[
          'We used enyzme 2-succinyl-6-hydroxy-2,4-',
          'cyclohexadiene-1-carboxylate synthase.',
        ]),
      );

      expect(
        wrap(text1, width: 10),
        equals(<String>[
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
        ]),
      );

      expect(
        wrap(text2, width: 10),
        equals(<String>[
          '1234567890',
          '-123456789',
          '0--this_is',
          '_a_very_lo',
          'ng_option_',
          'indeed-',
          'good-bye"',
        ]),
      );
    });

    test('break long words not on hyphen', () {
      expect(
        wrap(text1, width: 50, breakOnHyphens: false),
        equals(<String>[
          'We used enyzme 2-succinyl-6-hydroxy-2,4-cyclohexad',
          'iene-1-carboxylate synthase.',
        ]),
      );

      expect(
        wrap(text1, width: 10, breakOnHyphens: false),
        equals(<String>[
          'We used',
          'enyzme 2-s',
          'uccinyl-6-',
          'hydroxy-2,',
          '4-cyclohex',
          'adiene-1-c',
          'arboxylate',
          'synthase.',
        ]),
      );

      expect(
        wrap(text2, width: 10),
        equals(<String>[
          '1234567890',
          '-123456789',
          '0--this_is',
          '_a_very_lo',
          'ng_option_',
          'indeed-',
          'good-bye"',
        ]),
      );
    });

    test('break on hyphen but not long words', () {
      expect(
        wrap(text1, width: 50, breakLongWords: false),
        equals(<String>[
          'We used enyzme',
          '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
          'synthase.',
        ]),
      );

      expect(
        wrap(text1, width: 10, breakLongWords: false),
        equals(<String>[
          'We used',
          'enyzme',
          '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
          'synthase.',
        ]),
      );

      expect(
        wrap(text2, width: 10),
        equals(<String>[
          '1234567890',
          '-123456789',
          '0--this_is',
          '_a_very_lo',
          'ng_option_',
          'indeed-',
          'good-bye"',
        ]),
      );
    });

    test('do not break long words or on hyphens', () {
      expect(
        wrap(text1, width: 50, breakLongWords: false, breakOnHyphens: false),
        equals(<String>[
          'We used enyzme',
          '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
          'synthase.',
        ]),
      );

      expect(
        wrap(text1, width: 10, breakLongWords: false, breakOnHyphens: false),
        equals(<String>[
          'We used',
          'enyzme',
          '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate',
          'synthase.',
        ]),
      );

      expect(
        wrap(text2, width: 10),
        equals(<String>[
          '1234567890',
          '-123456789',
          '0--this_is',
          '_a_very_lo',
          'ng_option_',
          'indeed-',
          'good-bye"',
        ]),
      );
    });
  });
}
