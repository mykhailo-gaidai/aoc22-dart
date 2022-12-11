import 'dart:io';

void main() {
  part1('bin/11/test');
  part1('bin/11/input');
  part2('bin/11/test');
  part2('bin/11/input');
}

void part2(String file) {
  var input = File(file).readAsLinesSync();

  final operations = input
      .where((element) => element.contains('Operation'))
      .map((e) => e.split(' = ')[1].split(' '))
      .map((List<String> e) => (int op1) {
            final op2 = e[2] == 'old' ? op1 : int.parse(e[2]);
            return e[1] == '*' ? op1 * op2 : op1 + op2;
          })
      .toList();
  List<int> testCriteria =
      input.where((element) => element.contains('Test')).map((e) => int.parse(e.split(' ').last)).toList();
  List<int> testTrue =
      input.where((element) => element.contains('true')).map((e) => int.parse(e.split(' ').last)).toList();
  List<int> testFalse =
      input.where((element) => element.contains('false')).map((e) => int.parse(e.split(' ').last)).toList();

  List<List<List<int>>> items = input
      .where((element) => element.contains('Starting items:'))
      .map((element) => element
          .split(': ')[1]
          .split(', ')
          .map((e) => int.parse(e))
          .map((i) => testCriteria.map((e) => i % e).toList())
          .toList())
      .toList();

  final inspections = <int, int>{};

  int rounds = 10000;
  for (int round = 0; round < rounds; round++) {
    for (int monkey = 0; monkey < items.length; monkey++) {
      inspections[monkey] = (inspections[monkey] ?? 0) + items[monkey].length;
      while (items[monkey].isNotEmpty) {
        var item = items[monkey].removeAt(0);
        for (int index = 0; index < item.length; index++) {
          item[index] = operations[monkey](item[index]) % testCriteria[index];
        }
        if (item[monkey] == 0) {
          items[testTrue[monkey]].add(item);
        } else {
          items[testFalse[monkey]].add(item);
        }
      }
    }
  }

  var list = inspections.entries.map((e) => e.value).toList();
  list.sort((a, b) => b.compareTo(a));

  print('part1, $file, ${list[0] * list[1]}');
}

void part1(String file) {
  var input = File(file).readAsLinesSync();
  List<Monkey> monkeys = [];

  Function(Int64)? operation;
  List<Int64> items = [];
  List<int> test = [];

  for (var line in input) {
    if (line.contains('Starting items')) {
      items = line.split(': ')[1].split(', ').map((e) => Int64.parseInt(e)).toList();
    } else if (line.contains('Operation')) {
      var op = line.split(' = ')[1].split(' ');
      operation = (Int64 operand1) {
        if (op[1] == '*') {
          if (op[2] == 'old') {
            return operand1 * operand1;
          } else {
            return operand1 * Int64.parseInt(op[2]);
          }
        } else {
          if (op[2] == 'old') {
            return operand1 + operand1;
          } else {
            return operand1 + Int64.parseInt(op[2]);
          }
        }
      };
    } else if (line.contains('Test:')) {
      test = [int.parse(line.split(' ').last)];
    } else if (line.contains('true')) {
      test.add(int.parse(line.split(' ').last));
    } else if (line.contains('false')) {
      test.add(int.parse(line.split(' ').last));
    } else if (line.contains('Monkey ') && test.isNotEmpty) {
      monkeys.add(Monkey(items, operation!, test));
    }
  }
  monkeys.add(Monkey(items, operation!, test));

  var inspections = {};

  int rounds = 20;
  for (var round = 0; round < rounds; round++) {
    for (int i = 0; i < monkeys.length; i++) {
      var monkey = monkeys[i];
      while (monkey.items.isNotEmpty) {
        var item = monkey.items.removeAt(0);
        var worryLevel = ((monkey.operation(item).toInt()) / 3).floor();
        var newMonkeyIndex = (worryLevel % monkey.test[0] == 0) ? monkey.test[1] : monkey.test[2];
        monkeys[newMonkeyIndex].items.add(Int64(worryLevel));
        inspections[i] = (inspections[i] ?? 0) + 1;
      }
    }
  }

  var list = inspections.entries.toList();
  list.sort((a, b) => b.value.compareTo(a.value));
  var monkeyBusiness = list[0].value * list[1].value;
  print('part1: $file: monkey business: $monkeyBusiness');
}

class Monkey {
  List<Int64> items = [];
  Function(Int64) operation;
  List<int> test;

  Monkey(this.items, this.operation, this.test);

  String toString() => 'Monkey: $items, $test';
}
