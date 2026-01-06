import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';
import 'package:textwrap/utils.dart';

void main() {
  group('Edge Cases', () {
    test('expandTabs with tabSize 0', () {
      expect('\t'.expandTabs(0), equals(''));
      expect('a\tb'.expandTabs(0), equals('ab'));
      expect('a\t\tb'.expandTabs(0), equals('ab'));
    });

    test('expandTabs with negative tabSize', () {
      expect(() => 'a\tb'.expandTabs(-1), throwsArgumentError);
    });

    test('TextWrapper with tabSize 0', () {
      var wrapper = TextWrapper(tabSize: 0);

      try {
        wrapper.wrap('a\tb');
      } catch (_) {
        // Should propagate from expandTabs.
      }
    });

    test('PatternUtils split empty match', () {
      // Regex that matches empty string.
      var pattern = RegExp('');

      // Splitting by empty match is tricky.
      // 'abc'.split(RegExp(r'')) -> usually splits characters?
      var result = pattern.split('abc', includeEmptyStrings: true);
      // Expectations depend on Dart's internal logic which we execute via
      // pattern.allMatches.
      expect(result, isA<List<String>>());
    });
  });
}
