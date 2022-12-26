import 'dart:io';

void main() {
  var testCubes = readCubes('bin/18/test');
  var cubes = readCubes('bin/18/input');

  print(solve1(testCubes));
  print(solve1(cubes));
}

int solve1(List<String> cubes) {
  var sides = cubes.map((element) {
    final e = element.split(',');
    var variations = [
      '${int.parse(e[0]) + 1},${e[1]},${e[2]}',
      '${int.parse(e[0]) - 1},${e[1]},${e[2]}',
      '${e[0]},${int.parse(e[1]) + 1},${e[2]}',
      '${e[0]},${int.parse(e[1]) - 1},${e[2]}',
      '${e[0]},${e[1]},${int.parse(e[2]) + 1}',
      '${e[0]},${e[1]},${int.parse(e[2]) - 1}'
    ];
    var containing = variations.where((it) => cubes.contains(it));
    return 6 - containing.length;
  });
  return sides.reduce((value, element) => value + element);
}

List<String> readCubes(String file) => File(file).readAsLinesSync();
