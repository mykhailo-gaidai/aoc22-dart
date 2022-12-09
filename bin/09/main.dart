import 'dart:io';

void main() {
  part1('bin/09/test');
  part1('bin/09/input');
  part2('bin/09/test2');
  part2('bin/09/input');
}

void part1(String file) {
  // read file as strings
  var input = File(file).readAsLinesSync();
  // store x,y coordinates for head and tail, starting with 0
  var head = [0, 0], tail = [0, 0];
  // store all visited coordinates
  var visited = {'0,0': true};
  // process each line
  for (final line in input) {
// get the direction and distance
    final direction = line[0];
    final distance = int.parse(line.substring(1));
    for (var i = 0; i < distance; i++) {
      // update the head
      switch (direction) {
        case 'U':
          head[1]++;
          break;
        case 'D':
          head[1]--;
          break;
        case 'R':
          head[0]++;
          break;
        case 'L':
          head[0]--;
          break;
      }
      // If the head is ever two steps directly up, down, left, or right from the tail, the tail must also move one step in that direction
      if (head[0] == tail[0] + 2 && head[1] == tail[1]) {
        tail[0]++;
      } else if (head[0] == tail[0] - 2 && head[1] == tail[1]) {
        tail[0]--;
      } else if (head[0] == tail[0] && head[1] == tail[1] + 2) {
        tail[1]++;
      } else if (head[0] == tail[0] && head[1] == tail[1] - 2) {
        tail[1]--;
      }
      // if the head and tail aren't touching and aren't in the same row or column, the tail always moves one step diagonally to keep up
      if ((head[0] - tail[0]).abs() > 1 || (head[1] - tail[1]).abs() > 1) {
        if (head[0] > tail[0]) {
          tail[0]++;
        } else {
          tail[0]--;
        }
        if (head[1] > tail[1]) {
          tail[1]++;
        } else {
          tail[1]--;
        }
      }
      // add tail coordinates to visited if not already there
      if (!visited.containsKey('${tail[0]},${tail[1]}')) {
        visited['${tail[0]},${tail[1]}'] = true;
      }
    }
  }

  var result = visited.length;
  // print 'part1' file and result
  print('part1 $file: $result');
}

void part2(String file) {
  var input = File(file).readAsLinesSync();
  // store x,y coordinates for head and 9 tails, starting with 0
  var head = [0, 0], tails = List.generate(9, (index) => [0, 0]);
  // store all visited coordinates
  var visited = {'0,0': true};
  // process each line
  for (final line in input) {
// get the direction and distance
    final direction = line[0];
    final distance = int.parse(line.substring(1));
    for (var i = 0; i < distance; i++) {
      // update the head
      switch (direction) {
        case 'U':
          head[1]++;
          break;
        case 'D':
          head[1]--;
          break;
        case 'R':
          head[0]++;
          break;
        case 'L':
          head[0]--;
          break;
      }
      // update the tails
      for (var t = 0; t < tails.length; t++) {
        var tempHead = t == 0 ? head : tails[t - 1];
        // If the head is ever two steps directly up, down, left, or right from the tail, the tail must also move one step in that direction
        if (tempHead[0] == tails[t][0] + 2 && tempHead[1] == tails[t][1]) {
          tails[t][0]++;
        } else if (tempHead[0] == tails[t][0] - 2 && tempHead[1] == tails[t][1]) {
          tails[t][0]--;
        } else if (tempHead[0] == tails[t][0] && tempHead[1] == tails[t][1] + 2) {
          tails[t][1]++;
        } else if (tempHead[0] == tails[t][0] && tempHead[1] == tails[t][1] - 2) {
          tails[t][1]--;
        }
        // if the tempHead and tails[t aren't touching and aren't in the same row or column, the tails[t always moves one step diagonally to keep up
        if ((tempHead[0] - tails[t][0]).abs() > 1 || (tempHead[1] - tails[t][1]).abs() > 1) {
          if (tempHead[0] > tails[t][0]) {
            tails[t][0]++;
          } else {
            tails[t][0]--;
          }
          if (tempHead[1] > tails[t][1]) {
            tails[t][1]++;
          } else {
            tails[t][1]--;
          }
        }
        // add tail coordinates to visited if not already there
        if (!visited.containsKey('${tails.last[0]},${tails.last[1]}')) {
          visited['${tails.last[0]},${tails.last[1]}'] = true;
        }
      }
    }
  }

  var result = visited.length;
  // print 'part1' file and result
  print('part2 $file: $result');
}
