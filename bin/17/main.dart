import 'dart:io';
import 'dart:math';

final width = 7;

void main() {
  var shapes = readRocks();
  var testWind = readWind('bin/17/test');
  var wind = readWind('bin/17/input');

  // print(solve(shapes, testWind, 2022));
  // print(solve(shapes, wind, 2022));
  print(solve(shapes, testWind, 1000000000000));
  print(solve(shapes, wind, 1000000000000));
}

int solve(List<Rock> rocks, List<String> wind, int rocksCount) {
  final Ground ground = Ground();

  var rockIndex = 0;
  var windIndex = 0;

  var cache = <String, List<CacheValue>>{};
  var result = 0;
  var savedHighest = 0;
  var remainingCycles = -1;

  while (rockIndex < rocksCount) {
    final originalRock = rocks[rockIndex % rocks.length];
    var rock =
        Rock(points: originalRock.points.map((e) => e.copyWith(x: e.x + 2, y: e.y + ground.highest + 4)).toList());
    var isFalling = false;

    while (true) {
      if (isFalling) {
        if (rock.canFall(ground)) {
          rock = rock.fallDown();
        } else {
          ground.add(rock);
          isFalling = false;
          rockIndex++;

          if (remainingCycles == -1) {
            // cache
            final key = '${windIndex % wind.length}';
            cache[key] ??= [];
            cache[key]!.add(CacheValue(rockIndex: rockIndex, windIndex: windIndex, highest: ground.highest));
            if (cache[key]!.length > 2) {
              var list = cache[key]!;
              final lastDelta = list.last.highest - list[list.length - 2].highest;
              final secondToLastDelta = list[list.length - 2].highest - list[list.length - 3].highest;
              if (lastDelta == secondToLastDelta) {
                final loopStart = list[0].highest;
                final loopLength = list[1].rockIndex - list[0].rockIndex;
                final loopCount = ((rocksCount - loopStart) / loopLength).floor();
                remainingCycles = rocksCount - (loopLength * loopCount) - list[0].rockIndex;
                result = loopStart + loopCount * lastDelta;
                savedHighest = ground.highest;
              }
            }
          } else {
            remainingCycles--;
            if (remainingCycles == 0) {
              var delta = ground.highest - savedHighest;
              result += delta;
              return result;
            }
          }
          break;
        }
      } else {
        final windDirection = wind[windIndex++ % wind.length];
        if (windDirection == '<') {
          rock = rock.moveLeft(ground);
        } else {
          rock = rock.moveRight(ground);
        }
      }
      isFalling = !isFalling;
    }
  }

  return ground.highest;
}

class CacheValue {
  final int rockIndex;
  final int windIndex;
  final int highest;

  CacheValue({required this.rockIndex, required this.windIndex, required this.highest});
}

class Point {
  final int x;
  final int y;

  Point({required this.x, required this.y});

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Point && other.x == x && other.y == y;
  }

  Point copyWith({int? x, int? y}) => Point(x: x ?? this.x, y: y ?? this.y);

  @override
  String toString() {
    return '{$x-$y}';
  }
}

class Rock {
  final List<Point> points;

  Rock({required this.points});

  bool canFall(Ground ground) => points.every((it) => !ground.contains(it.copyWith(y: it.y - 1)));

  Rock fallDown() => Rock(points: points.map((e) => e.copyWith(y: e.y - 1)).toList());

  Rock moveLeft(Ground ground) {
    final newRock = Rock(points: points.map((e) => e.copyWith(x: e.x - 1)).toList());
    final isNewRockValid = newRock.points.every((it) {
      return it.x >= 0 && !ground.contains(it);
    });
    return isNewRockValid ? newRock : this;
  }

  Rock moveRight(Ground ground) {
    final newRock = Rock(points: points.map((e) => e.copyWith(x: e.x + 1)).toList());
    final isNewRockValid = newRock.points.every((it) {
      return it.x < width && !ground.contains(it);
    });
    return isNewRockValid ? newRock : this;
  }

  @override
  String toString() {
    return points.join(', ');
  }
}

class Ground {
  final Set<Point> points = List.generate(width, (index) => index).map((e) => Point(x: e, y: 0)).toSet();
  var highest = 0;

  bool intersects(Rock rock) => rock.points.any((element) => points.contains(element));

  bool contains(Point point) => points.contains(point);

  void add(Rock rock) {
    points.addAll(rock.points);
    highest = rock.points.fold(highest, (previousValue, element) => max(previousValue, element.y));
  }
}

List<String> readWind(String file) => File(file).readAsStringSync().split('');

List<Rock> readRocks() {
  var result = <Rock>[];
  var currentRock = <Point>[];

  var row = 0;
  var input = File('bin/17/shapes').readAsLinesSync();

  for (var line in input) {
    if (line.isEmpty) {
      var maxY = currentRock.reduce((value, element) => value.y > element.y ? value : element).y;
      result.add(Rock(points: currentRock.map((e) => e.copyWith(y: maxY - e.y)).toList()));
      currentRock = [];
      row = 0;
      continue;
    }

    for (var col = 0; col < line.length; col++) {
      if (line[col] == '#') {
        currentRock.add(Point(x: col, y: row));
      }
    }
    row++;
  }

  result.add(Rock(points: currentRock));

  return result;
}
