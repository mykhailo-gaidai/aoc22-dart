import 'dart:io';

void main() {
  part1('input/04/test');
  part1('input/04/input');
  part2('input/04/test');
  part2('input/04/input');
}

void part1(String file) {
  var lines = File(file).readAsLinesSync();
  var result = 0;
  for (final line in lines) {
    final sets = line.split(',').expand((e) => e.split('-')).map((e) => int.parse(e)).toList();
    if ((sets[0] >= sets[2] && sets[1] <= sets[3]) || (sets[0] <= sets[2] && sets[1] >= sets[3])) {
      result++;
    }
  }
  print('$file: $result');
}

void part2(String file) {
  var lines = File(file).readAsLinesSync();
  var result = 0;
  for (final line in lines) {
    final sets = line.split(',').expand((e) => e.split('-')).map((e) => int.parse(e)).toList();
    final a1 = sets[0], a2 = sets[1], a3 = sets[2], a4 = sets[3];
    if ((a1 >= a3 && a1 <= a4) || (a2 >= a3 && a2 <= a4) || (a3 >= a1 && a3 <= a2) || (a4 >= a1 && a4 <= a2)) {
      result++;
    }
  }
  print('$file: $result');
}
