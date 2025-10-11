import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

void main() {
  group('ShortenTestCase', () {
    test('simple', () {
      var text = "Hello there, how are you this fine day? I'm glad to hear it!";

      expect(shorten(text, 18), equals('Hello there, ...'));
      expect(shorten(text, text.length), equals(text));

      expect(
        shorten(text, text.length - 1),
        equals("Hello there, how are you this fine day? I'm glad to ..."),
      );
    });

    test('placeholder', () {
      var text = "Hello there, how are you this fine day? I'm glad to hear it!";

      expect(
        shorten(text, 17, placeholder: '\$\$'),
        equals('Hello there,\$\$'),
      );

      expect(
        shorten(text, 18, placeholder: '\$\$'),
        equals('Hello there, how\$\$'),
      );

      expect(
        shorten(text, 18, placeholder: ' \$\$'),
        equals('Hello there, \$\$'),
      );

      expect(shorten(text, text.length, placeholder: '\$\$'), equals(text));

      expect(
        shorten(text, text.length - 1, placeholder: '\$\$'),
        equals("Hello there, how are you this fine day? I'm glad to hear\$\$"),
      );
    });

    test('empty string', () {
      expect(shorten('', 6), equals(''));
    });

    test('whitespace', () {
      var text = '''
            This is a  paragraph that  already has
            line breaks and \t tabs too.''';

      expect(
        shorten(text, 62),
        equals(
          'This is a paragraph that already has line breaks and tabs too.',
        ),
      );

      expect(
        shorten(text, 61),
        equals('This is a paragraph that already has line breaks and tabs ...'),
      );

      expect(
        shorten('hello      world!  ', 12, placeholder: ' [...]'),
        equals('hello world!'),
      );

      expect(
        shorten('hello      world!  ', 11, placeholder: ' [...]'),
        equals('hello [...]'),
      );

      expect(
        shorten('hello      world!  ', 10, placeholder: ' [...]'),
        equals('[...]'),
      );
    });

    test('width too small for placeholder', () {
      shorten('x' * 20, 8, placeholder: '(......)');

      expect(
        () => shorten('x' * 20, 8, placeholder: '(.......)'),
        throwsStateError,
      );
    });

    test('first word too long but placeholder fits', () {
      expect(shorten('Helloo', 5), equals('...'));
    });
  });
}
