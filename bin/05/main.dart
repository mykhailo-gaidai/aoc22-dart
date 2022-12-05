import 'dart:collection';
import 'dart:io';

void main() {
  part1('bin/05/test');
  part1('bin/05/input');
  part2('bin/05/test');
  part2('bin/05/input');
}

void part2(String file) {
  var lines = File(file).readAsLinesSync();
  var length = 0;
  var i = 0;
  // go through lines until there is digit
  while (i < lines.length) {
    if (lines[i].contains(RegExp(r'[0-9]'))) {
      break;
    }
    i++;
  }
  // parse last number from the line
  var stackCount = int.parse(lines[i].split(' ').last);
  // create stackCount number of lists
  var stacks = List.generate(stackCount, (index) => <String>[]);
  // go through lines until there is digit
  i = 0;
  while (i < lines.length) {
    if (lines[i].contains(RegExp(r'[0-9]'))) {
      break;
    }
    for (var j = 0; j < stackCount; j++) {
      final position = 1 + j * 4;
      if (lines[i].length < position) {
        break;
      }
      if (lines[i][position] == ' ') {
        continue;
      }
      stacks[j].add(lines[i][position]);
    }
    i++;
  }
  // fill instructions
  i += 2;
  var instructions = <Instruction>[];
  while (i < lines.length) {
    // parse all numbers from line via regex
    final numbers =
    lines[i].split(RegExp(r'[^0-9]')).where((element) => element.isNotEmpty).map((e) => int.parse(e)).toList();
    instructions.add(Instruction(numbers[0], numbers[1] - 1, numbers[2] - 1));
    i++;
  }
  // print('stacks: $stacks');
  // execute instructions
  for (final instr in instructions) {
    // repeat x times
    stacks[instr.to].insertAll(0, stacks[instr.from].sublist(0, instr.count));
    stacks[instr.from].removeRange(0, instr.count);
    // print('instr: $instr, stacks: $stacks');
  }
  var result = stacks.map((e) => e.first).join();
  print('part1: $file: $result');
}

void part1(String file) {
  var lines = File(file).readAsLinesSync();
  var length = 0;
  var i = 0;
  // go through lines until there is digit
  while (i < lines.length) {
    if (lines[i].contains(RegExp(r'[0-9]'))) {
      break;
    }
    i++;
  }
  // parse last number from the line
  var stackCount = int.parse(lines[i].split(' ').last);
  // create stackCount number of lists
  var stacks = List.generate(stackCount, (index) => <String>[]);
  // go through lines until there is digit
  i = 0;
  while (i < lines.length) {
    if (lines[i].contains(RegExp(r'[0-9]'))) {
      break;
    }
    for (var j = 0; j < stackCount; j++) {
      final position = 1 + j * 4;
      if (lines[i].length < position) {
        break;
      }
      if (lines[i][position] == ' ') {
        continue;
      }
      stacks[j].add(lines[i][position]);
    }
    i++;
  }
  // fill instructions
  i += 2;
  var instructions = <Instruction>[];
  while (i < lines.length) {
    // parse all numbers from line via regex
    final numbers =
        lines[i].split(RegExp(r'[^0-9]')).where((element) => element.isNotEmpty).map((e) => int.parse(e)).toList();
    instructions.add(Instruction(numbers[0], numbers[1] - 1, numbers[2] - 1));
    i++;
  }
  // print('stacks: $stacks');
  // execute instructions
  for (final instr in instructions) {
    // repeat x times
    for (var z = 0; z < instr.count; z++) {
      stacks[instr.to].insert(0, stacks[instr.from].removeAt(0));
    }
    // print('instr: $instr, stacks: $stacks');
  }
  var result = stacks.map((e) => e.first).join();
  print('part1: $file: $result');
}

class Instruction {
  final int count;
  final int from;
  final int to;

  Instruction(this.count, this.from, this.to);

  @override
  String toString() {
    return 'Instruction{count: $count, from: $from, to: $to}';
  }
}
