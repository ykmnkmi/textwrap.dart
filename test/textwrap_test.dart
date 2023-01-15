import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

const emptyList = <Object?>[];

void main() {
  group('TextWrapper', () {
    void check(Object result, Object expekt) {
      expect(result, equals(expekt));
    }

    test('simple', () {
      var text = 'Hello there, how are you this fine day?  '
          "I'm glad to hear it!";

      check(wrap(text, width: 12), [
        'Hello there,',
        'how are you',
        'this fine',
        "day?  I'm",
        'glad to hear',
        'it!',
      ]);

      check(wrap(text, width: 42), [
        'Hello there, how are you this fine day?',
        "I'm glad to hear it!",
      ]);

      check(wrap(text, width: 80), [
        text,
      ]);
    });

    test('empty string', () {
      check(wrap('', width: 6), emptyList);
      check(wrap('', width: 6, dropWhitespace: false), emptyList);
    });

    test('empty string with initial indent', () {
      check(wrap('', width: 6, initialIndent: '++'), emptyList);
      check(wrap('', width: 6, initialIndent: '++', dropWhitespace: false),
          emptyList);
    });

    test('whitespace', () {
      var text = '''\
This is a paragraph that already has
line breaks.  But some of its lines are much longer than the others,
so it needs to be wrapped.
Some lines are \ttabbed too.
What a mess!
''';
      var expekt = [
        'This is a paragraph that already has line',
        'breaks.  But some of its lines are much',
        'longer than the others, so it needs to be',
        'wrapped.  Some lines are  tabbed too.  What a',
        'mess!',
      ];

      var wrapper = TextWrapper(width: 45, fixSentenceEndings: true);
      check(wrapper.wrap(text), expekt);
      check(wrapper.fill(text), expekt.join('\n'));
    });

    test('white space 2', () {
      var text = '\tTest\tdefault\t\ttabsize.';
      check(wrap(text, width: 80), [
        '        Test    default         tabsize.',
      ]);

      text = '\tTest\tcustom\t\ttabsize.';
      check(wrap(text, width: 80, tabSize: 4), [
        '    Test    custom      tabsize.',
      ]);
    });
  });
}
