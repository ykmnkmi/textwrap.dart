// ignore_for_file: non_constant_identifier_names

import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:textwrap/textwrap.dart';

import 'base_test_case.dart';

@reflectiveTest
final class ShortenTestCase extends BaseTestCase {
  void checkShorten(
    String text,
    int width,
    String expected, {
    String placeholder = ' [...]',
  }) {
    var result = shorten(text, width, placeholder: placeholder);
    expect(result, expected);
  }

  void test_simple() {
    var text = "Hello there, how are you this fine day? I'm glad to hear it!";

    checkShorten(text, 18, 'Hello there, [...]');
    checkShorten(text, text.length, text);
    checkShorten(
      text,
      text.length - 1,
      "Hello there, how are you this fine day? I'm glad to [...]",
    );
  }

  void test_placeholder() {
    var text = "Hello there, how are you this fine day? I'm glad to hear it!";

    checkShorten(text, 17, 'Hello there,\$\$', placeholder: '\$\$');
    checkShorten(text, 18, 'Hello there, how\$\$', placeholder: '\$\$');
    checkShorten(text, 18, 'Hello there, \$\$', placeholder: ' \$\$');
    checkShorten(text, text.length, text, placeholder: '\$\$');
    checkShorten(
      text,
      text.length - 1,
      "Hello there, how are you this fine day? I'm glad to hear\$\$",
      placeholder: '\$\$',
    );
  }

  void test_empty_string() {
    checkShorten('', 6, '');
  }

  void test_whitespace() {
    var text = '''
            This is a  paragraph that  already has
            line breaks and \t tabs too.''';
    checkShorten(
      text,
      62,
      'This is a paragraph that already has line breaks and tabs too.',
    );
    checkShorten(
      text,
      61,
      'This is a paragraph that already has line breaks and [...]',
    );

    checkShorten('hello      world!  ', 12, 'hello world!');
    checkShorten('hello      world!  ', 11, 'hello [...]');
    checkShorten('hello      world!  ', 10, '[...]');
  }

  void test_width_too_small_for_placeholder() {
    shorten('x' * 20, 8, placeholder: '(......)');
    expect(
      () => shorten('x' * 20, 8, placeholder: '(.......)'),
      throwsStateError,
    );
  }

  void test_first_word_too_long_but_placeholder_fits() {
    checkShorten('Helloo', 5, '[...]');
  }
}
