# textwrap

[![Pub Package][pub_icon]][pub]
[![Test Status][test_ci_icon]][test_ci]
[![CodeCov][codecov_icon]][codecov]

A Dart library for intelligent text wrapping and filling. This is a pure port of Python's [textwrap module][textwrap], providing powerful text formatting utilities for console applications, documentation generation, and formatted output.

## Features

- **Smart text wrapping** with customizable width and indentation
- **Paragraph filling** that preserves formatting
- **Flexible indentation** for first line and subsequent lines
- **Whitespace handling** with configurable options
- **Long word breaking** for words that exceed line width
- **Pure Dart implementation** with no external dependencies

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  textwrap: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Text Wrapping

```dart
import 'package:textwrap/textwrap.dart';

void main() {
  // Simple wrapping
  print(fill('Text wrapping and filling with intelligent line breaks.', width: 16));
  // Output:
  // Text wrapping
  // and filling
  // with
  // intelligent line
  // breaks.
}
```

### Advanced Options

```dart
import 'package:textwrap/textwrap.dart';

void main() {
  final text = 'This is a long paragraph that needs to be wrapped nicely.';

  // Wrap with custom indentation
  print(fill(text,
    width: 30,
    initialIndent: '>>> ',
    subsequentIndent: '    '
  ));
  // Output:
  // >>> This is a long paragraph
  //     that needs to be wrapped
  //     nicely.

  // Just get the wrapped lines as a list
  final lines = wrap(text, width: 20);

  for (final line in lines) {
    print('| $line');
  }
}
```

### Using TextWrapper class

For repeated text wrapping with the same configuration, use the `TextWrapper` class:

```dart
import 'package:textwrap/textwrap.dart';

void main() {
  // Create a reusable wrapper with specific settings
  final wrapper = TextWrapper(
    width: 40,
    initialIndent: '  ',
    subsequentIndent: '    ',
    breakLongWords: false,
  );

  // Apply the same formatting to multiple texts
  print(wrapper.fill('First paragraph to be wrapped with consistent formatting.'));
  print('');
  print(wrapper.fill('Second paragraph with the same indentation and width settings.'));

  // Get lines as a list
  final lines = wrapper.wrap('Third paragraph for line-by-line processing.');
}
```

### Text Shortening

```dart
import 'package:textwrap/textwrap.dart';

void main() {
  final longText = 'This is a very long piece of text that needs to be shortened';

  // Shorten text to fit in limited space
  print(shorten(longText, 30));
  // Output: 'This is a very long piece ...'

  // Custom placeholder
  print(shorten(longText, 25, placeholder: ' [more]'));
  // Output: 'This is a very [more]'
}
```

### Working with Code and Preformatted Text

```dart
final code = '''
def hello_world():
    print("Hello, World!")
    return True
''';

// Preserve indentation while wrapping
print(fill(code, width: 25, expandTabs: false));
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[pub_icon]: https://img.shields.io/pub/v/textwrap.svg
[pub]: https://pub.dev/packages/textwrap
[test_ci_icon]: https://github.com/ykmnkmi/textwrap.dart/actions/workflows/test.yaml/badge.svg
[test_ci]: https://github.com/ykmnkmi/textwrap.dart/actions/workflows/test.yaml
[codecov_icon]: https://codecov.io/gh/ykmnkmi/textwrap.dart/branch/main/graph/badge.svg?token=LJ5SL5GWHY
[codecov]: https://app.codecov.io/gh/ykmnkmi/textwrap.dart
[textwrap]: https://github.com/python/cpython/blob/master/Lib/textwrap.py
[tracker]: https://github.com/ykmnkmi/textwrap.dart/issues
