import 'dart:io';

void main() {
  part1('bin/15/test', 10);
  part1('bin/15/input', 2000000);
}

void part1(String file, int row) {
  var xmin = 2147483648, xmax = -2147483648, ymax = -2147483648, ymin = 2147483648;
  final beacons = File(file).readAsLinesSync().map((e) {
    var parts = e.split(' ');
    var x1 = int.parse(parts[2].substring(2, parts[2].length - 1));
    var y1 = int.parse(parts[3].substring(2, parts[3].length - 1));
    var x2 = int.parse(parts[8].substring(2, parts[8].length - 1));
    var y2 = int.parse(parts[9].substring(2));
    if (x1 < xmin) xmin = x1;
    if (x1 > xmax) xmax = x1;
    if (x2 < xmin) xmin = x2;
    if (x2 > xmax) xmax = x2;
    if (y1 < ymin) ymin = y1;
    if (y1 > ymax) ymax = y1;
    if (y2 < ymin) ymin = y2;
    if (y2 > ymax) ymax = y2;
    return [x1, y1, x2, y2, (x1 - x2).abs() + (y1 - y2).abs()];
  }).toList();

  final t = xmax - xmin;
  xmin -= t;
  xmax += t;

  var count = 0;
  for (var x = xmin; x <= xmax; x++) {
    if (beacons.any((e) => (x - e[0]).abs() + (row - e[1]).abs() <= e[4]) && !beacons.any((e) => x == e[2] && row == e[3])) {
      count++;
    }
  }

  print('part1: $file, $count');
}
