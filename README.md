# textwrap

[![Pub Package][pub_icon]][pub]
[![Test Status][test_ci_icon]][test_ci]
[![CodeCov][codecov_icon]][codecov]

Text wrapping and filling. It's a pure port of [textwrap][textwrap] from Python.

## Usage

A simple usage example:

```dart
import 'package:textwrap/textwrap.dart';

void main() {
  print(fill('Text wrapping and filling.', width: 16));
  // Text wrapping
  // and filling.
}
```

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
