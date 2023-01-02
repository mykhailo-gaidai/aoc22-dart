import 'dart:io';

void main() {
  assert(solve1('bin/22/test') == 6032);
  print(solve1('bin/22/input'));
  // 2290 too low
}

int solve1(String filename) {
  var map = readMap(filename);
  var path = readPath(filename);

  var height = map.length;
  var width = map.fold(0, (previousValue, element) => previousValue > element.length ? previousValue : element.length);

  var row = 0;
  var col = map.first.indexOf('.');
  var facing = 0;

  for (var action in path) {
    if (action == 'L') {
      facing = (facing - 1) % 4;
      continue;
    }

    if (action == 'R') {
      facing = (facing + 1) % 4;
      continue;
    }

    int distance = int.parse(action);

    for (var i = 0; i < distance; i++) {
      var nextRow = row;
      var nextCol = col;

      switch (facing) {
        case 0:
          if (col < width - 1) {
            nextCol = col + 1;
          } else {
            nextCol = map[row].split('').indexWhere((element) => element != ' ');
          }

          if (map[nextRow][nextCol] == ' ') {
            nextCol = map[row].split('').indexWhere((element) => element != ' ');
          }
          break;
        case 1:
          if (row < height - 1) {
            nextRow = row + 1;
          } else {
            nextRow = map.indexWhere((element) => element[col] != ' ');
          }

          if (map[nextRow][nextCol] == ' ') {
            nextRow = map.indexWhere((element) => element[col] != ' ');
          }
          break;
        case 2:
          if (col > 0) {
            nextCol = col - 1;
          } else {
            nextCol = map[row].split('').lastIndexWhere((element) => element != ' ');
          }

          if (map[nextRow][nextCol] == ' ') {
            nextCol = map[row].split('').lastIndexWhere((element) => element != ' ');
          }
          break;
        default:
          if (row > 0) {
            nextRow = row - 1;
          } else {
            nextRow = map.lastIndexWhere((element) => element[nextCol] != ' ');
          }

          if (map[nextRow][nextCol] == ' ') {
            nextRow = map.lastIndexWhere((element) => element[nextCol] != ' ');
          }
          break;
      }

      if (map[nextRow][nextCol] != '#') {
        row = nextRow;
        col = nextCol;
        var dir = '.';
        if (facing == 0) {
          dir = '>';
        } else if (facing == 1) {
          dir = 'V';
        } else if (facing == 2) {
          dir = '<';
        } else {
          dir = '^';
        }
        map[row] = map[row].replaceRange(col, col+1, dir);
      } else {
        break;
      }
    }
  }

  print('==============================================================================================');
  for (var line in map) {
    print(line);
  }

  return 1000 * (row + 1) + 4 * (col + 1) + facing;
}

List<String> readMap(String filename) {
  var input = File(filename).readAsLinesSync();
  input = input.sublist(0, input.length - 2);
  var width = input.fold(0, (previousValue, element) => previousValue > element.length ? previousValue : element.length);
  input = input.map((e) => e.padRight(width, ' ')).toList();
  return input;
}

List<String> readPath(String filename) {
  var input = File(filename).readAsLinesSync();
  var rawPath = input.last;
  var path = <String>[];
  var s = '';
  for (var i = 0; i < rawPath.length; i++) {
    if (rawPath[i] == 'R' || rawPath[i] == 'L') {
      path.add(s);
      path.add(rawPath[i]);
      s = '';
    } else {
      s += rawPath[i];
    }
  }
  path.add(s);
  return path;
}
