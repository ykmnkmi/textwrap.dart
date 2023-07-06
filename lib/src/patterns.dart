final RegExp spaceRe = RegExp('\\s+');

final RegExp sentenceEndRe = RegExp('\\w[\\.\\!\\?][\\"\']?\$');

final RegExp wordSeparatorSimpleRe = RegExp('([\t\n\v\r ])+');

final RegExp wordSeparatorRe = RegExp(
    '([\t\n\v\r ]+|(?<=[\\w!"\'&.,?])-{2,}(?=\\w)|[^\t\n\v\r ]+?'
    '(?:-(?:(?<=[^\\d\\W]{2}-)|(?<=[^\\d\\W]-[^\\d\\W]-))(?=[^\\d\\W]-?[^\\d\\W])|'
    '(?=[\t\n\v\r ]|\$)|(?<=[\\w!"\'&.,?])(?=-{2,}\\w)))');
