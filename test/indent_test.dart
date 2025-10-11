import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

void main() {
  group('IndentTestCases', () {
    var text = '''
This paragraph will be filled, first without any indentation,
and then with some (including a hanging indent).''';

    test('fill', () {
      var expected = '''
This paragraph will be filled, first
without any indentation, and then with
some (including a hanging indent).''';

      var result = fill(text, width: 40);
      expect(result, equals(expected));
    });

    test('initial indent', () {
      var expected = <String>[
        '     This paragraph will be filled,',
        'first without any indentation, and then',
        'with some (including a hanging indent).',
      ];

      var result = wrap(text, width: 40, initialIndent: '     ');
      expect(result, equals(expected));

      var fillExpected = expected.join('\n');
      var fillResult = fill(text, width: 40, initialIndent: '     ');
      expect(fillResult, equals(fillExpected));
    });

    test('subsequent indent', () {
      var expected = '''
  * This paragraph will be filled, first
    without any indentation, and then
    with some (including a hanging
    indent).''';

      var result = fill(
        text,
        width: 40,
        initialIndent: '  * ',
        subsequentIndent: '    ',
      );

      expect(result, equals(expected));
    });
  });
}
