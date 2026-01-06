import 'package:test/test.dart';
import 'package:textwrap/textwrap.dart';

void main() {
  group('HandleLongWordCoverage', () {
    // We use wrapChunks directly to bypass split(), ensuring handleLongWord is
    // called with the exact chunks we want, effectively simulating
    // "unwrappable" chunks that trigger the long word logic.

    test('break at hyphen', () {
      var wrapper = TextWrapper(
        width: 6,
        breakLongWords: true,
        breakOnHyphens: true,
      );

      // "hello-world"
      // Width 6. Substring "hello-".
      // Hyphen at 5. Precedent 'o'. Valid break.
      // Expected: "hello-", "world".
      expect(wrapper.wrapChunks(['hello-world']), equals(['hello-', 'world']));
    });

    test('do not break at double dash second hyphen', () {
      var wrapper = TextWrapper(
        width: 6,
        breakLongWords: true,
        breakOnHyphens: true,
      );

      // "abc--def"
      // Width 6. Substring "abc--d".
      // Hyphen at 4. Precedent '-'. Invalid break (suppressed).
      // Falls back to breaking at width: "abc--d".
      // Expected: "abc--d", "ef".
      expect(wrapper.wrapChunks(['abc--def']), equals(['abc--d', 'ef']));
    });

    test('breakLongWords false with long word', () {
      var wrapper = TextWrapper(width: 5, breakLongWords: false);
      // Should keep it as one line.
      expect(
        wrapper.wrapChunks(['supercalifragilistic']),
        equals(['supercalifragilistic']),
      );
    });

    test('breakLongWords true but no hyphens', () {
      var wrapper = TextWrapper(width: 5, breakLongWords: true);
      expect(wrapper.wrapChunks(['abcdefgh']), equals(['abcde', 'fgh']));
    });
  });
}
