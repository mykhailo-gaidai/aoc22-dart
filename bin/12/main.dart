import 'dart:io';

void main() {
  // part1('bin/12/test');
  part1('bin/12/input');
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
        .where((element) => !queue.contains(element)) );
  }

  print('part1,$file , no path found');
}

const heights = 'SabcdefghijklmnopqrstuvwxyzE';
