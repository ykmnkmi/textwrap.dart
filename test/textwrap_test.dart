import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'indent_test_cases.dart';
import 'long_word_test_case.dart';
import 'long_word_with_hyphens_test_case.dart';
import 'max_lines_test_case.dart';
import 'shorten_test_case.dart';
import 'wrap_test_case.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(WrapTestCase);
    defineReflectiveTests(MaxLinesTestCase);
    defineReflectiveTests(LongWordTestCase);
    defineReflectiveTests(LongWordWithHyphensTestCase);
    defineReflectiveTests(IndentTestCases);
    defineReflectiveTests(ShortenTestCase);
  });
}
