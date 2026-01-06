import 'package:test/test.dart';
import 'package:textwrap/utils.dart';

void main() {
  group('PatternUtils', () {
    test('split simple', () {
      Pattern pattern = ' ';
      expect(pattern.split('a b c'), equals(['a', 'b', 'c']));
      expect(pattern.split(' a b c '), equals(['', 'a', 'b', 'c', '']));
    });

    test('split simple string inclideEmptyStrings', () {
      Pattern pattern = ' ';
      expect(
        pattern.split(' a  b ', includeEmptyStrings: true),
        equals(['', 'a', '', 'b', '']),
      );

      // String.split behavior on multiple separators might differ slightly
      // depending on implementation but PatternUtils.split(String) delegates
      // to String.split if not RegExp. String.split keeps empty strings by
      // default.
    });

    test('split regex', () {
      var pattern = RegExp(r'\s+');
      expect(pattern.split('a   b c'), equals(['a', 'b', 'c']));
    });

    test('split regex with capturing group', () {
      var pattern = RegExp(r'(\d+)');
      expect(pattern.split('a123b456c'), equals(['a', '123', 'b', '456', 'c']));
    });

    test('split regex inclideEmptyStrings', () {
      var pattern = RegExp('-');
      expect(
        pattern.split('-a--b-', includeEmptyStrings: true),
        equals(['', 'a', '', 'b', '']),
      );
      expect(pattern.split('-a--b-'), equals(['a', 'b']));
    });

    test('split backward compatibility', () {
      var pattern = RegExp('-');
      expect(
        // ignore: deprecated_member_use_from_same_package
        pattern.split('-a--b-', inclideEmptyStrings: true),
        equals(['', 'a', '', 'b', '']),
      );
    });
  });

  group('StringUtils', () {
    group('expandTabs', () {
      test('defaults', () {
        expect(
          'abc\rab\tdef\ng\thi'.expandTabs(),
          'abc\rab      def\ng       hi',
        );
      });

      test('specific tab size', () {
        expect(
          'abc\rab\tdef\ng\thi'.expandTabs(8),
          'abc\rab      def\ng       hi',
        );
        expect('abc\rab\tdef\ng\thi'.expandTabs(4), 'abc\rab  def\ng   hi');
      });

      test('with CRLF', () {
        expect(
          'abc\r\nab\tdef\ng\thi'.expandTabs(),
          'abc\r\nab      def\ng       hi',
        );
        expect(
          'abc\r\nab\tdef\ng\thi'.expandTabs(8),
          'abc\r\nab      def\ng       hi',
        );
        expect('abc\r\nab\tdef\ng\thi'.expandTabs(4), 'abc\r\nab  def\ng   hi');
      });

      test('mixed line endings', () {
        expect(
          'abc\r\nab\r\ndef\ng\r\nhi'.expandTabs(4),
          'abc\r\nab\r\ndef\ng\r\nhi',
        );
      });

      test('tab size 1', () {
        expect(' \ta\n\tb'.expandTabs(1), '  a\n b');
      });

      test('tab size 0', () {
        expect(' \ta\n\tb'.expandTabs(0), ' a\nb');
        expect('a\t\tb'.expandTabs(0), 'ab');
      });
    });

    group('translate', () {
      test('simple replacement', () {
        expect('hello'.translate({101: 69}), equals('hEllo')); // e->E
      });

      test('multiple replacements', () {
        expect('hello'.translate({104: 72, 108: 76}), equals('HeLLo'));
      });

      test('no matching characters', () {
        expect('hello'.translate({122: 90}), equals('hello')); // z->Z
      });

      test('empty map', () {
        expect('hello'.translate({}), equals('hello'));
      });

      test('empty string', () {
        expect(''.translate({101: 69}), equals(''));
      });
    });
  });
}
