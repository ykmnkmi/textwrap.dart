part of '../textwrap.dart';

// dart format off

final RegExp _spaceRe = RegExp('\\s+');

final RegExp _sentenceEndRe = RegExp(
  '\\p{Ll}'                                     // Lowercase letter
  '[.!?]'                                       // Sentence-ending punctuation
  '["\']?'                                      // Optional quote
  '\$',                                         // End of string
  unicode: true,
);

final RegExp _wordSeparatorSimpleRe = RegExp('([\t\n\x0b\x0c\r ]+)');

const _l = '\\p{L}';                            // Unicode letters ONLY
const _wp = '[\\w\\p{L}!"\'&.,?]';              // Word chars + Unicode letters + punctuation
const _ws = '[\t\n\x0b\x0c\r ]';                // Whitespace
const _nws = '[^\t\n\x0b\x0c\r ]';              // Non-whitespace

final RegExp _wordSeparatorRe = RegExp(
  '('                                           // GROUP 1: Match one of:
    '$_ws+'                                     //   ├─ Whitespace sequence
    '|'                                         //   │
    '(?<=$_wp)-{2,}(?=[\\w\\p{L}])'             //   ├─ Em-dash (word-punct)---(word)
    '|'                                         //   │
    '$_nws+?'                                   //   └─ Word + one of:
    '(?:'                                       //       ├─ Hyphenated word break:
      '-'                                       //       │   ├─ hyphen after
      '(?:'                                     //       │   │   ├─ (letter)(letter)-
        '(?<=$_l{2}-)'                          //       │   │   └─ (letter)-(letter)-
        '|'                                     //       │   │
        '(?<=$_l-$_l-)'                         //       │   └─ before (letter)-?(letter)
      ')'                                       //       │
      '(?=$_l-?$_l)'                            //       │
      '|'                                       //       │
      '(?=$_ws|\$)'                             //       ├─ End of word (whitespace/end)
      '|'                                       //       │
      '(?<=$_wp)(?=-{2,}[\\w\\p{L}])'           //       └─ Before em-dash (punct)---(word)
    ')'
  ')',
  unicode: true,
);
