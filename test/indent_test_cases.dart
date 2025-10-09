// ignore_for_file: non_constant_identifier_names

import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:textwrap/textwrap.dart';

import 'base_test_case.dart';

@reflectiveTest
final class IndentTestCases extends BaseTestCase {
  final text = '''
This paragraph will be filled, first without any indentation,
and then with some (including a hanging indent).''';

  void test_fill() {
    var expected = '''
This paragraph will be filled, first
without any indentation, and then with
some (including a hanging indent).''';

    var result = fill(text, width: 40);
    expect(result, expected);
  }

  void test_initial_indent() {
    var expected = [
      '     This paragraph will be filled,',
      'first without any indentation, and then',
      'with some (including a hanging indent).',
    ];
    var result = wrap(text, width: 40, initialIndent: '     ');
    expect(result, expected);

    var fillExpected = expected.join('\n');
    var fillResult = fill(text, width: 40, initialIndent: '     ');
    expect(fillResult, fillExpected);
  }

  void test_subsequent_indent() {
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
    expect(result, expected);
  }
}
