import 'package:test/test.dart';
import 'package:textwrap/utils.dart';

void main() {
  test('expandTabs', () {
    expect('abc\rab\tdef\ng\thi'.expandTabs(), 'abc\rab      def\ng       hi');
    expect('abc\rab\tdef\ng\thi'.expandTabs(8), 'abc\rab      def\ng       hi');
    expect('abc\rab\tdef\ng\thi'.expandTabs(4), 'abc\rab  def\ng   hi');
    expect('abc\r\nab\tdef\ng\thi'.expandTabs(), 'abc\r\nab      def\ng       hi');
    expect('abc\r\nab\tdef\ng\thi'.expandTabs(8), 'abc\r\nab      def\ng       hi');
    expect('abc\r\nab\tdef\ng\thi'.expandTabs(4), 'abc\r\nab  def\ng   hi');
    expect('abc\r\nab\r\ndef\ng\r\nhi'.expandTabs(4), 'abc\r\nab\r\ndef\ng\r\nhi');
    expect('abc\rab\tdef\ng\thi'.expandTabs(8), 'abc\rab      def\ng       hi');
    expect('abc\rab\tdef\ng\thi'.expandTabs(4), 'abc\rab  def\ng   hi');
    expect(' \ta\n\tb'.expandTabs(1), '  a\n b');
  });
}
