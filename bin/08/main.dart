import 'dart:io';

void main() {
  part1('bin/08/test');
  part1('bin/08/input');
  part2('bin/08/test');
  part2('bin/08/input');
}

void part2(String file) {
  var input = File(file).readAsLinesSync();

  final width = input[0].length, height = input.length;
  final trees = {};

  for (var row = 0; row < height; row++) {
    for (var col = 0; col < width; col++) {
      trees['$row,$col'] = int.parse(input[row][col]);
    }
  }

  var max = 0;

  for (var row = 1; row < height - 1; row++) {
    for (var col = 1; col < width - 1; col++) {
      var currentHeight = trees['$row,$col'];
      var top = 0, bottom = 0, left = 0, right = 0;

      var topIndex =
          List.generate(row, (index) => trees['$index,$col']).lastIndexWhere((element) => element >= currentHeight);
      if (topIndex == -1) {
        top = row;
      } else {
        top = row - topIndex;
      }
      var bottomIndex = List.generate(height - row - 1, (index) => trees['${index + row + 1},$col'])
          .indexWhere((element) => element >= currentHeight);
      if (bottomIndex == -1) {
        bottom = height - row - 1;
      } else {
        bottom = bottomIndex + 1;
      }

      var leftIndex =
          List.generate(col, (index) => trees['$row,$index']).lastIndexWhere((element) => element >= currentHeight);
      if (leftIndex == -1) {
        left = col;
      } else {
        left = col - leftIndex;
      }

      var rightIndex = List.generate(width - col - 1, (index) => trees['$row,${index + col + 1}'])
          .indexWhere((element) => element >= currentHeight);
      if (rightIndex == -1) {
        right = width - col - 1;
      } else {
        right = rightIndex + 1;
      }

      final score = top * bottom * left * right;
      if (max < score) {
        max = score;
      }
    }
  }

  print('part2: $file: $max');
}

void part1(String file) {
  var input = File(file).readAsLinesSync();

  final width = input[0].length, height = input.length;
  final trees = {};

  for (var row = 0; row < height; row++) {
    for (var col = 0; col < width; col++) {
      trees['$row,$col'] = int.parse(input[row][col]);
    }
  }

  var result = 0;

  for (var row = 1; row < height - 1; row++) {
    for (var col = 1; col < width - 1; col++) {
      final current = trees['$row,$col'];

      final isNotVisibleFromTop =
          List.generate(row, (index) => trees['$index,$col']).any((element) => element >= current);
      final isNotVisibleFromBottom = List.generate(height - row - 1, (index) => trees['${row + index + 1},$col'])
          .any((element) => element >= current);
      final isNotVisibleFromLeft =
          List.generate(col, (index) => trees['$row,${col - index - 1}']).any((element) => element >= current);
      final isNotVisibleFromRight = List.generate(width - col - 1, (index) => trees['$row,${col + index + 1}'])
          .any((element) => element >= current);
      if (isNotVisibleFromTop && isNotVisibleFromBottom && isNotVisibleFromLeft && isNotVisibleFromRight) {
        continue;
      }
      result++;
    }
  }

  result += width * 2 + height * 2 - 4;

  print('part1: $file: $result');
}
