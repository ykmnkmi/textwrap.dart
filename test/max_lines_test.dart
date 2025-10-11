import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

void main() {
  group('MaxLinesTestCase', () {
    var text = "Hello there, how are you this fine day?  I'm glad to hear it!";

    test('simple', () {
      expect(wrap(text, width: 12, maxLines: 0), equals(<String>['Hello ...']));
      expect(wrap(text, width: 12, maxLines: 1), equals(<String>['Hello ...']));

      expect(
        wrap(text, width: 12, maxLines: 2),
        equals(<String>['Hello there,', 'how are ...']),
      );

      expect(
        wrap(text, width: 13, maxLines: 2),
        equals(<String>['Hello there,', 'how are ...']),
      );

      expect(wrap(text, width: 80, maxLines: 1), equals(<String>[text]));

      expect(
        wrap(text, width: 12, maxLines: 6),
        equals(<String>[
          'Hello there,',
          'how are you',
          'this fine',
          "day?  I'm",
          'glad to hear',
          'it!',
        ]),
      );
    });

    test('spaces', () {
      expect(
        wrap(text, width: 12, maxLines: 4),
        equals(<String>[
          'Hello there,',
          'how are you',
          'this fine',
          'day? ...',
        ]),
      );

      expect(
        wrap(text, width: 6, maxLines: 2),
        equals(<String>['Hello', '...']),
      );

      expect(
        wrap('$text          ', width: 12, maxLines: 6),
        equals(<String>[
          'Hello there,',
          'how are you',
          'this fine',
          "day?  I'm",
          'glad to hear',
          'it!',
        ]),
      );
    });

    test('placeholder', () {
      expect(
        wrap(text, width: 12, maxLines: 1, placeholder: '...'),
        equals(<String>['Hello...']),
      );

      expect(
        wrap(text, width: 12, maxLines: 2, placeholder: '...'),
        equals(<String>['Hello there,', 'how are...']),
      );

      expect(
        () => wrap(
          text,
          width: 16,
          initialIndent: '    ',
          maxLines: 1,
          placeholder: ' [truncated]...',
        ),
        throwsStateError,
      );

      expect(
        () => wrap(
          text,
          width: 16,
          subsequentIndent: '    ',
          maxLines: 2,
          placeholder: ' [truncated]...',
        ),
        throwsStateError,
      );

      expect(
        wrap(
          text,
          width: 16,
          maxLines: 2,
          initialIndent: '    ',
          subsequentIndent: '  ',
          placeholder: ' [truncated]...',
        ),
        equals(<String>['    Hello there,', '  [truncated]...']),
      );

      expect(
        wrap(
          text,
          width: 16,
          maxLines: 1,
          initialIndent: '  ',
          subsequentIndent: '    ',
          placeholder: ' [truncated]...',
        ),
        equals(<String>['  [truncated]...']),
      );

      expect(wrap(text, width: 80, placeholder: '.' * 1000), <String>[text]);
    });

    test('placeholder backtrack', () {
      var text = 'Good grief Dart features are advancing quickly!';

      expect(
        wrap(text, width: 12, maxLines: 3, placeholder: '*****'),
        equals(<String>['Good grief', 'Dart*****']),
      );
    });
  });
}
