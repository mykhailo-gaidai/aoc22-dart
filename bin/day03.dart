import 'dart:io';

void main() {
  part1('input/03/test');
  part1('input/03/input');
  part2('input/03/test');
  part2('input/03/input');
}

const _priorities = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

void part1(String file) {
  // read file as strings
  var lines = File(file).readAsLinesSync();
  var result = 0;
  for (final line in lines) {
    // split line in the middle
    final first = line.substring(0, line.length ~/ 2);
    final second = line.substring(line.length ~/ 2);
    // find unique characters that exist in both strings
    final intersection = first.split('').where((element) => second.contains(element));
    final unique = intersection.toSet();
    // add priorities for each character to result
    for (final character in unique) {
      result += _priorities.indexOf(character)+1;
    }
  }

  print('$file: $result');
}

void part2(String file) {
  // read file as strings
  var lines = File(file).readAsLinesSync();
  var result = 0;

  // read lines by 3
  for (var i = 0; i < lines.length; i += 3) {
    final first = lines[i];
    final second = lines[i+1];
    final third = lines[i+2];
    // find unique characters that exist in all strings
    final intersection = first.split('').where((element) => second.contains(element) && third.contains(element));
    final unique = intersection.toSet();
    // add priorities for each character to result
    for (final character in unique) {
      result += _priorities.indexOf(character)+1;
    }
  }

  print('$file: $result');
}
