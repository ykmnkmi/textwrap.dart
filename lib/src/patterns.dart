/// Regular expression that matches one or more whitespace characters.
///
/// Used for collapsing multiple consecutive whitespace characters into
/// single spaces during text normalization.
///
/// Example matches: ' ', '   ', '\t\n ', '\r\n\t'
final RegExp spaceRe = RegExp('\\s+');

/// Regular expression that matches sentence endings.
///
/// Matches a word character followed by a sentence terminator (period,
/// exclamation mark, or question mark), optionally followed by closing
/// quotes. Used to identify locations where double spacing should be
/// applied after sentence endings.
///
/// Pattern breakdown:
/// - `\\w` - matches any word character
/// - `[\\.\\!\\?]` - matches period, exclamation, or question mark
/// - `[\\"\']?` - optionally matches closing quote marks
/// - `\$` - matches end of string/line
///
/// Example matches: 'word.', 'text!', 'question?', 'quote."', "end!'"
final RegExp sentenceEndRe = RegExp('\\w[\\.\\!\\?][\\"\']?\$');

/// Simple regular expression for splitting text at basic whitespace boundaries.
///
/// Matches sequences of tab, newline, vertical tab, carriage return, and
/// space characters. Used when hyphen-based word breaking is disabled.
///
/// Characters matched:
/// - `\\t` - tab
/// - `\\n` - newline
/// - `\\v` - vertical tab
/// - `\\r` - carriage return
/// - ` ` - space
///
/// Example: Splits "hello world\ttest" into ["hello", "world", "test"]
final RegExp wordSeparatorSimpleRe = RegExp('([\\t\\n\\v\\r ])+');

/// Complex regular expression for sophisticated word boundary detection.
///
/// This pattern handles advanced text splitting including hyphenated words,
/// em-dashes, and complex punctuation scenarios. It preserves meaningful
/// hyphens while breaking at appropriate word boundaries.
///
/// Pattern components:
/// 1. `[\\t\\n\\v\\r ]+` - whitespace sequences
/// 2. `(?<=[\\w!"'&.,?])-{2,}(?=\\w)` - em-dashes between words
/// 3. Complex hyphen handling for compound words
/// 4. Lookaheads/lookbehinds for context-sensitive breaking
///
/// This regex enables intelligent wrapping that:
/// - Preserves compound words like "self-evident"
/// - Handles em-dashes in text like "word—another"
/// - Maintains proper punctuation attachment
/// - Supports complex hyphenation rules
///
/// Example: Splits "well-known example—with dashes" appropriately
/// while preserving meaningful word relationships.
final RegExp wordSeparatorRe = RegExp(
  '([\t\n\v\r ]+|(?<=[\\w!"\'&.,?])-{2,}(?=\\w)|[^\t\n\v\r ]+?'
  '(?:-(?:(?<=[^\\d\\W]{2}-)|(?<=[^\\d\\W]-[^\\d\\W]-))(?=[^\\d\\W]-?[^\\d\\W])|'
  '(?=[\t\n\v\r ]|\$)|(?<=[\\w!"\'&.,?])(?=-{2,}\\w)))',
);
