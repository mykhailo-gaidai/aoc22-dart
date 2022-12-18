import 'dart:io';
import 'dart:math';

void main() {
  part1('bin/14/test');
  part1('bin/14/input');
}

void part1(String file) {
  final input = File(file).readAsLinesSync();

  var xmin = 500, xmax = 500, ymax = 0;

  var rocks = <String>[];
  for (final line in input) {
    var points = line.split(' -> ');
    // sliding window
    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final finish = points[i + 1];

      final x1 = int.parse(start.split(',')[0]);
      final y1 = int.parse(start.split(',')[1]);
      final x2 = int.parse(finish.split(',')[0]);
      final y2 = int.parse(finish.split(',')[1]);

      if (x1 == x2) {
        if (x1 < xmin) xmin = x1;
        if (x1 > xmax) xmax = x1;
        for (var y = min(y1, y2); y <= max(y1, y2); y++) {
          if (y > ymax) ymax = y;
          rocks.add('$x1,$y');
        }
      } else {
        if (y1 > ymax) ymax = y1;
        for (var x = min(x1, x2); x <= max(x1, x2); x++) {
          if (x < xmin) xmin = x;
          if (x > xmax) xmax = x;
          rocks.add('$x,$y1');
        }
      }
    }
  }

  var count = 0;
  var current = '500,0';
  while (true) {
    final x = int.parse(current.split(',')[0]);
    final y = int.parse(current.split(',')[1]);
    if (x < xmin || x > xmax || y > ymax) {
      break;
    }

    // try to move down
    if (!rocks.contains('$x,${y + 1}')) {
      current = '$x,${y + 1}';
    } else if (!rocks.contains('${x - 1},${y + 1}')) {
      current = '${x - 1},${y + 1}';
    } else if (!rocks.contains('${x + 1},${y + 1}')) {
      current = '${x + 1},${y + 1}';
    } else {
      count++;
      rocks.add(current);
      current = '500,0';
    }
  }
  print('Part 1: $file, $count');
}
