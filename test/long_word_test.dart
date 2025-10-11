import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

void main() {
  group('LongWordTestCase', () {
    var text = '''
Did you say "supercalifragilisticexpialidocious?"
How *do* you spell that odd word, anyways?
''';

    test('break long', () {
      expect(
        wrap(text, width: 30),
        equals(<String>[
          'Did you say "supercalifragilis',
          'ticexpialidocious?" How *do*',
          'you spell that odd word,',
          'anyways?',
        ]),
      );

      expect(
        wrap(text, width: 50),
        equals(<String>[
          'Did you say "supercalifragilisticexpialidocious?"',
          'How *do* you spell that odd word, anyways?',
        ]),
      );

      expect(
        wrap('${'-' * 10}hello', width: 10, subsequentIndent: ' ' * 15),
        equals(<String>[
          '----------',
          '               h',
          '               e',
          '               l',
          '               l',
          '               o',
        ]),
      );

      expect(
        wrap(text, width: 12),
        equals(<String>[
          'Did you say ',
          '"supercalifr',
          'agilisticexp',
          'ialidocious?',
          '" How *do*',
          'you spell',
          'that odd',
          'word,',
          'anyways?',
        ]),
      );
    });

    test('nobreak long', () {
      var wrapper = TextWrapper(breakLongWords: false, width: 30);

      var expected = <String>[
        'Did you say',
        '"supercalifragilisticexpialidocious?"',
        'How *do* you spell that odd',
        'word, anyways?',
      ];

      var result = wrapper.wrap(text);
      expect(result, equals(expected));

      result = wrap(text, width: 30, breakLongWords: false);
      expect(result, equals(expected));
    });

    test('max lines long', () {
      expect(
        wrap(text, width: 12, maxLines: 4),
        equals(<String>['Did you say ', '"supercalifr', 'agilisticexp', '...']),
      );
    });
  });
}
