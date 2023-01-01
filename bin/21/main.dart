import 'dart:io';


void main() {
  assert(solve1('bin/21/test') == 152);
  assert(solve1('bin/21/input') == 84244467642604);
  assert(solve2('bin/21/test') == 301);
  print(solve2('bin/21/input'));
}

int solve2(String filename) {
  var rawInput = File(filename).readAsLinesSync();
  var input = <String, String>{};
  for (var value in rawInput) {
    var parts = value.split(': ');
    input[parts[0]] = parts[1];
  }

  bool containsHumn(String what) {
    if (what == 'humn') {
      return true;
    }
    var valueOfWhat = input[what];
    if (valueOfWhat == null) {
      print('no value for $what');
      return false;
    }
    var parts = valueOfWhat.split(' ');
    if (parts.length == 1) {
      return false;
    }
    return [parts[0], parts[2]].any((element) => containsHumn(element));
  }

  var rootParts = input['root']!.split(' ');
  var contains = containsHumn(rootParts[0]) ? rootParts[0] : rootParts[2];
  var targetName = contains == rootParts[0] ? rootParts[2] : rootParts[0];

  int calculate(String name) {
    var split = input[name]!.split(' ');
    if (split.length == 1) {
      return int.parse(split[0]);
    }

    switch(split[1]) {
      case '+': return calculate(split[0]) + calculate(split[2]);
      case '*': return calculate(split[0]) * calculate(split[2]);
      case '-': return calculate(split[0]) - calculate(split[2]);
      default: return calculate(split[0]) ~/ calculate(split[2]);
    }
  }

  var calculate2 = calculate(targetName);

  int findHumn(String name, int target) {
    var split = input[name]!.split(' ');
    if (name == 'humn') {
      return target;
    }

    var containsH = containsHumn(split[0]) ? split[0] : split[2];
    var another = containsH == split[0] ? split[2] : split[0];

    switch(split[1]) {
      case '+': return findHumn(containsH, target - calculate(another));
      case '*': return findHumn(containsH, target ~/ calculate(another));
      case '-':
        if (containsH == split[0]) {
          return findHumn(containsH, target + calculate(another));
        } else {
          return findHumn(containsH, calculate(another) - target);
        }
      default:
        if (containsH == split[0]) {
          return findHumn(containsH, target * calculate(another));
        } else {
          return findHumn(containsH, calculate(another) ~/ target);
        }
    }
  }

  var result = findHumn(contains, calculate2);
  return result;
}

int solve1(String filename) {
  var input = File(filename).readAsLinesSync();

  var numbers = <String, int>{};
  input.where((it) => it.split(' ').length == 2).forEach((it) {
    numbers[it.split(' ')[0].substring(0, 4)] = int.parse(it.split(' ')[1]);
  });

  var queue = input.where((it) => it.split(' ').length > 2).toList();
  while (queue.isNotEmpty) {
    var solvable = queue.where((it) => it.split(' ').where((it) => numbers.containsKey(it)).length == 2).toList();
    for (var it in solvable) {
      var parts = it.split(' ');
      var a = numbers[parts[1]]!;
      var b = numbers[parts[3]]!;
      var result;
      switch (parts[2]) {
        case '+':
          result = a + b;
          break;
        case '*':
          result = a * b;
          break;
        case '-':
          result = a - b;
          break;
        default:
          result = a ~/ b;
          break;
      }
      numbers[parts[0].substring(0, 4)] = result;
      queue.remove(it);
    }
  }

  return numbers['root']!;
}
