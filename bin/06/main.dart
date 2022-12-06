import 'dart:io';

void main() {
  part1(inputs: [
    'mjqjpqmgbljsphdztnvjfqwrcgsmlb',
    'bvwbjplbgvbhsrlpgdmjqwftvncz',
    'nppdvjthqldpwncqszvftbrmjlhg',
    'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg',
    'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw',
  ]);
  part1(file: 'bin/06/input');
  part2(inputs: [
    'mjqjpqmgbljsphdztnvjfqwrcgsmlb',
    'bvwbjplbgvbhsrlpgdmjqwftvncz',
    'nppdvjthqldpwncqszvftbrmjlhg',
    'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg',
    'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw',
  ]);
  part2(file: 'bin/06/input');
}

void part1({String? file, List<String>? inputs}) {
  final input = inputs ?? File(file!).readAsLinesSync();
  for (final line in input) {
    for (var i = 4; i < line.length; i++) {
      final window = line.substring(i - 4, i);
      // break if all the characters are different
      if (window[0] != window[1] &&
          window[0] != window[2] &&
          window[0] != window[3] &&
          window[1] != window[2] &&
          window[1] != window[3] &&
          window[2] != window[3]) {
        print('part1: ${line.substring(0, 5)}: $i');
        break;
      }
    }
  }
}

void part2({String? file, List<String>? inputs}) {
  final input = inputs ?? File(file!).readAsLinesSync();
  for (final line in input) {
    for (var i = 14; i < line.length; i++) {
      final window = line.substring(i - 14, i);
      // break if all the characters are different
      if (window.split('').toSet().length == 14) {
        print('part2: ${line.substring(0, 5)}: $i');
        break;
      }
    }
  }
}
