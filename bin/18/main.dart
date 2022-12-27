import 'dart:io';

void main() {
  var testCubes = readCubes('bin/18/test');
  var cubes = readCubes('bin/18/input');

  print(findAllSides(testCubes));
  print(findAllSides(cubes));

  print(solve2(testCubes));
  print(solve2(cubes));
  // 3732 too high
  // 216 too low
}

int solve2(List<Cube> cubes) {
  int maxx = 0, minx = 9999999, maxy = 0, miny = 9999999, maxz = 0, minz = 9999999;
  for (var cube in cubes) {
    if (cube.x > maxx) maxx = cube.x;
    if (cube.x < minx) minx = cube.x;
    if (cube.y > maxy) maxy = cube.y;
    if (cube.y < miny) miny = cube.y;
    if (cube.z > maxz) maxz = cube.z;
    if (cube.z < minz) minz = cube.z;
  }

  var potentiallyInternal = <Cube>[];
  for (var x = minx + 1; x < maxx; x++) {
    for (var y = miny + 1; y < maxy; y++) {
      for (var z = minz + 1; z < maxz; z++) {
        var cube = Cube(x, y, z);
        if (!cubes.contains(cube) &&
            cubes.any((element) => element.x == x && element.y == y && element.z > z) &&
            cubes.any((element) => element.x == x && element.y == y && element.z < z) &&
            cubes.any((element) => element.x == x && element.y > y && element.z == z) &&
            cubes.any((element) => element.x == x && element.y < y && element.z == z) &&
            cubes.any((element) => element.x > x && element.y == y && element.z == z) &&
            cubes.any((element) => element.x < x && element.y == y && element.z == z)) {
          potentiallyInternal.add(cube);
        }
      }
    }
  }

  final internalSingles = [...potentiallyInternal.where((element) => element.adjacent.every((element) => cubes.contains(element)))];
  for (var value in internalSingles) {
    potentiallyInternal.remove(value);
  }
  var result = findAllSides(cubes) - internalSingles.length * 6;

  var allAreas = <List<Cube>>[];
  var area = <Cube>[];

  while (potentiallyInternal.isNotEmpty) {
    if (area.isEmpty) {
      area.add(potentiallyInternal.removeAt(0));
    }
    var adjacent = [...potentiallyInternal.where((e) => area.any((element) => element.adjacent.contains(e)))];
    while (adjacent.isNotEmpty) {
      area.addAll(adjacent);
      for (var value in adjacent) {
        potentiallyInternal.remove(value);
      }
      adjacent = [...potentiallyInternal.where((e) => area.any((element) => element.adjacent.contains(e)))];
    }

    allAreas.add([...area]);
    area.clear();
  }

  for (var a in allAreas) {
    var edge = a.expand((element) => element.adjacent.where((element) => !a.contains(element)));
    if (edge.any((element) => !cubes.contains(element))) {
      continue;
    }

    result -= findAllSides(a);
  }

  return result;
}

int findAllSides(List<Cube> cubes) => cubes
    .map((element) => 6 - element.adjacent.where((it) => cubes.contains(it)).length)
    .reduce((value, element) => value + element);

List<Cube> readCubes(String file) => File(file).readAsLinesSync().map((e) => Cube.fromString(e)).toList();

class Cube {
  final int x;
  final int y;
  final int z;

  Cube(this.x, this.y, this.z);

  Cube.fromString(String s) : this(int.parse(s.split(',')[0]), int.parse(s.split(',')[1]), int.parse(s.split(',')[2]));

  List<Cube> get adjacent => [
        Cube(x - 1, y, z),
        Cube(x + 1, y, z),
        Cube(x, y - 1, z),
        Cube(x, y + 1, z),
        Cube(x, y, z - 1),
        Cube(x, y, z + 1),
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cube && runtimeType == other.runtimeType && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;

  @override
  String toString() => '{$x,$y,$z}';
}
