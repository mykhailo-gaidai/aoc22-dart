import 'dart:io';

void main() {
  // part1('bin/12/test');
  // part1('bin/12/input');
  part2('bin/12/test');
  part2('bin/12/input');
}

void part2(String file) {
  // read file as strings
  final input = File(file).readAsLinesSync();

  final heightMap = <String, int>{};
  final stepsMap = <String, int>{};

  var list = <String>[];

  for (var row = 0; row < input.length; row++) {
    for (var col = 0; col < input[row].length; col++) {
      var currentHeight = heights.indexOf(input[row][col]);
      heightMap['$row,$col'] = currentHeight;
      stepsMap['$row,$col'] = currentHeight < 2 ? 0 : -1;
      if (currentHeight == 1) {
        if (!list.contains('$row,$col')) list.add('$row,$col');
      }
    }
  }

  var step = 0;
  while (list.isNotEmpty) {
    for (var e in list) {
      stepsMap[e] = step;
    }
    step++;

    list = list
        .expand((cur) {
          final row = int.parse(cur.split(',')[0]);
          final col = int.parse(cur.split(',')[1]);
          return [
            '$row,${col - 1}',
            '$row,${col + 1}',
            '${row - 1},$col',
            '${row + 1},$col',
          ].where((element) => (heightMap[element] ?? heights.length) <= heightMap[cur]! + 1);
        })
        .toSet()
        .where((e) => stepsMap[e] == -1)
        .toList();
  }

  var eKey = heightMap.entries.where((element) => element.value == heights.length - 1).first.key;
  print('part2, $file, ${stepsMap[eKey]}');
}

void part1(String file) {
  // read file as strings
  final input = File(file).readAsLinesSync();

  List<List<String>> heightMap = input.map((e) => e.split('')).toList();

  final startRow = heightMap.indexWhere((element) => element.contains('S'));
  final startCol = heightMap[startRow].indexOf('S');

  final stepsMap = List.generate(heightMap.length, (index) => List.generate(heightMap[0].length, (index) => -1));

  var queue = <String>[
    '$startRow,$startCol',
  ];

  var step = 0;

  while (queue.isNotEmpty) {
    print('step ${step++}, queue length ${queue.length}');
    var current = queue.removeAt(0).split(',');
    final row = int.parse(current[0]);
    final col = int.parse(current[1]);
    final currentHeight = heights.indexOf(heightMap[row][col]);
    var cellsAround = [
      [row - 1, col],
      [row + 1, col],
      [row, col - 1],
      [row, col + 1]
    ].where((e) => e[0] >= 0 && e[0] < heightMap.length && e[1] >= 0 && e[1] < heightMap[0].length).toList();
    final stepsAround = cellsAround.map((e) => stepsMap[e[0]][e[1]]).toList();
    stepsAround.sort((a, b) => b.compareTo(a));
    final currentSteps = stepsAround[0] + 1;
    if (currentHeight == heights.length - 1) {
      print('part1, $file, $currentSteps');
      return;
    }
    stepsMap[row][col] = currentSteps;
    queue.addAll(cellsAround
        .where((e) => stepsMap[e[0]][e[1]] < 0 && heights.indexOf(heightMap[e[0]][e[1]]) <= currentHeight + 1)
        .map((e) => '${e[0]},${e[1]}')
        .where((element) => !queue.contains(element)));
  }

  print('part1,$file , no path found');
}

const heights = 'SabcdefghijklmnopqrstuvwxyzE';
