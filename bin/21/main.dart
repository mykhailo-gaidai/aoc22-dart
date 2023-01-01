import 'dart:io';

void main() {
  assert(solve('bin/21/test') == 152);
  print(solve('bin/21/input'));
}

int solve(String filename) {
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
