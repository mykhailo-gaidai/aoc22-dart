import 'dart:io';

void main() {
  part1('bin/10/test');
  part1('bin/10/input');
  part2('bin/10/test');
  part2('bin/10/input');
}

void part1(String file) {
  // rad file as strings
  var input = File(file).readAsLinesSync();
  // store current cycle and x value
  var cycle = 1, x = 1;
  var result = 0;
  // for each line in input
  for (final line in input) {
    // print('cycle: $cycle, x: $x, line: $line');

    if ([20, 60, 100, 140, 180, 220].contains(cycle)) {
      // print('cycle: $cycle, x: $x, strength = ${cycle * x}');
      result += cycle * x;
    }
    cycle++;

    var command = line.split(' ');
    if (command[0] == 'addx') {
      if ([20, 60, 100, 140, 180, 220].contains(cycle)) {
        // print('*cycle: $cycle, x: $x, strength = ${cycle * x}');
        result += cycle * x;
      }
      cycle++;
      x += int.parse(command[1]);
    }
  }
  print('part1: $file: $result');
}

void part2(String file) {
  print('part2: $file');
  // rad file as strings
  var input = File(file).readAsLinesSync();
  // store current cycle and x value
  var cycle = 0, x = 1;
  var result = 0;
  var row = '';
  // for each line in input
  for (final line in input) {
    row += (x - cycle % 40).abs() < 2 ? '#' : '.';
    cycle++;
    if (cycle % 40 == 0) {
      print(row);
      row = '';
    }

    var command = line.split(' ');
    if (command[0] == 'addx') {
      var add = int.parse(command[1]);
      row += (x - cycle % 40).abs() < 2 ? '#' : '.';
      cycle++;
      if (cycle % 40 == 0) {
        print(row);
        row = '';
      }
      x += add;
    }
  }
}
