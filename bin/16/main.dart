import 'dart:io';

void main() {
  part1('bin/16/test');
  part1('bin/16/input');
  part2('bin/16/test');
  part2('bin/16/input');
  // 2536 too low
}

void part2(String file) {
  var maxMinutes = 26;

  final input = File(file).readAsLinesSync().map((e) {
    final parts = e.split(' ');
    final valve = parts[1];
    final flowRate = parts[4].replaceAll('rate=', '').replaceAll(';', '');
    final exits = parts.sublist(9).map((e) => e.replaceAll(',', ''));
    return [valve, flowRate, exits.toList()];
  });

  int distance({required String from, required String to}) {
    var steps = 0;
    var visited = <String>{};
    var current = [from];
    while (current.isNotEmpty) {
      steps++;
      visited.addAll(current);
      current = input
          .where((i) => current.contains(i[0]))
          .expand((e) => e[2] as List<String>)
          .where((e) => !visited.contains(e))
          .toList();
      if (current.contains(to)) return steps;
    }
    return 0;
  }

  final openables = {
    for (var item in input.where((element) => element[1] != '0')) item[0] as String: int.parse(item[1] as String)
  };
  Map<String, Map<String, int>> buildRoutes() {
    final result = <String, Map<String, int>>{};

    final destinations = ['AA', ...openables.keys];
    for (var i = 0; i < destinations.length - 1; i++) {
      for (var j = i + 1; j < destinations.length; j++) {
        final from = destinations[i];
        final to = destinations[j];
        final d = distance(from: from, to: to);
        result[from] ??= {};
        result[from]![to] = d;
        result[to] ??= {};
        result[to]![from] = d;
      }
    }

    return result;
  }

  final routes = buildRoutes();

  int calculateMinutes(List<String> path) {
    var result = 0;
    for (var i = 0; i < path.length - 1; i++) {
      result += routes[path[i]]![path[i + 1]]! + 1;
    }
    return result;
  }

  int calculateValue(List<String> path) {
    var result = 0;
    var minutes = 0;
    for (var i = 0; i < path.length - 1; i++) {
      final from = path[i];
      final to = path[i + 1];
      minutes += routes[from]![to]! + 1;
      if (minutes > maxMinutes) {
        print('Too long: $path, $result, next addition = ${openables[to]! * (maxMinutes - minutes)}');
      }
      result += openables[to]! * (maxMinutes - minutes);
    }
    return result;
  }

  var cache = <String, int>{};

  String getCacheKey(int minutes, List<String> remaining) => '${minutes}_${remaining.join(',')}';

  int findMax(List<String> path1, List<String> path2, List<String> remaining) {
    final cacheKey = '${path1.join(',')}_${path2.join(',')}';
    if (cache.containsKey(cacheKey)) {
      return cache[cacheKey]!;
    }

    final minutes1 = calculateMinutes(path1);
    final minutes2 = calculateMinutes(path2);

    if (remaining.isEmpty) {
      return calculateValue(path1) + calculateValue(path2);
    }

    var outcomes = <Outcome>[];

    for (var it in remaining) {
      if (minutes1 + routes[path1.last]![it]! + 1 < maxMinutes) {
        var value = findMax([...path1, it], path2, [...remaining]..remove(it));
        outcomes.add(Outcome(move: it, value: value));
      }
      if (minutes2 + routes[path2.last]![it]! + 1 < maxMinutes) {
        var value = findMax(path1, [...path2, it], [...remaining]..remove(it));
        outcomes.add(Outcome(move: it, value: value));
      }
    }

    if (outcomes.isEmpty) {
      return calculateValue(path1) + calculateValue(path2);
    }

    final sorted = outcomes..sort((a, b) => b.value.compareTo(a.value));
    final best = sorted.first;
    cache['${path1.join(',')}_${path2.join(',')}'] = best.value;
    cache['${path2.join(',')}_${path1.join(',')}'] = best.value;
    return best.value;
  }

  final result = findMax(['AA'], ['AA'], openables.keys.toList());
  print('Part 2, $file,  $result');
}

class Outcome {
  String move;
  int value;
  Outcome({required this.move, required this.value});
}

void part1(String file) {
  final input = File(file).readAsLinesSync().map((e) {
    final parts = e.split(' ');
    final valve = parts[1];
    final flowRate = parts[4].replaceAll('rate=', '').replaceAll(';', '');
    final exits = parts.sublist(9).map((e) => e.replaceAll(',', ''));
    return [valve, flowRate, exits.toList()];
  });

  int distance({required String from, required String to}) {
    var steps = 0;
    var visited = <String>{};
    var current = [from];
    while (current.isNotEmpty) {
      steps++;
      visited.addAll(current);
      current = input
          .where((i) => current.contains(i[0]))
          .expand((e) => e[2] as List<String>)
          .where((e) => !visited.contains(e))
          .toList();
      if (current.contains(to)) return steps;
    }
    return 0;
  }

  final openables = {
    for (var item in input.where((element) => element[1] != '0')) item[0] as String: int.parse(item[1] as String)
  };
  Map<String, Map<String, int>> buildRoutes() {
    final result = <String, Map<String, int>>{};

    final destinations = ['AA', ...openables.keys];
    for (var i = 0; i < destinations.length - 1; i++) {
      for (var j = i + 1; j < destinations.length; j++) {
        final from = destinations[i];
        final to = destinations[j];
        final d = distance(from: from, to: to);
        result[from] ??= {};
        result[from]![to] = d;
        result[to] ??= {};
        result[to]![from] = d;
      }
    }

    return result;
  }

  final routes = buildRoutes();

  var maxMinutes = 30;

  Route getBestRoute(Route route) {
    final options = openables.keys
        .where((it) => !route.path.contains(it))
        .where((it) => route.minutes + routes[route.path.last]![it]! + 1 < maxMinutes);

    if (options.isEmpty) {
      return route;
    }

    final variants = options.map((it) {
      final newPath = {...route.path, it};
      final newMinutes = route.minutes + routes[route.path.last]![it]! + 1;
      final newValue = route.value + openables[it]! * (maxMinutes - newMinutes);
      return getBestRoute(Route(path: newPath, minutes: newMinutes, value: newValue));
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return variants.first;
  }

  final bestRoute = getBestRoute(Route(path: {'AA'}, minutes: 0, value: 0));
  print('part1, $file, ${bestRoute.path} (${bestRoute.value})');
}

class Route2 {
  final Set<String> path1;
  final Set<String> path2;
  final int minutes1;
  final int minutes2;
  final int value;

  Route2(
      {required this.path1, required this.path2, required this.value, required this.minutes1, required this.minutes2});

  @override
  int get hashCode => path1.hashCode + path2.hashCode + minutes1.hashCode + minutes2.hashCode;

  equals(Route2 other) =>
      (path1 == other.path1 && path2 == other.path2 && minutes1 == other.minutes1 && minutes2 == other.minutes2) ||
      (path1 == other.path2 && path2 == other.path1 && minutes1 == other.minutes2 && minutes2 == other.minutes1);

  @override
  String toString() => 'Route2{path1: $path1, path2: $path2, value: $value, minutes1: $minutes1, minutes2: $minutes2}';

  Route2 copyWith({Set<String>? path1, Set<String>? path2, int? minutes1, int? minutes2, int? value}) {
    return Route2(
        path1: path1 ?? this.path1,
        path2: path2 ?? this.path2,
        minutes1: minutes1 ?? this.minutes1,
        minutes2: minutes2 ?? this.minutes2,
        value: value ?? this.value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Route2 &&
        other.path1 == path1 &&
        other.path2 == path2 &&
        other.minutes1 == minutes1 &&
        other.minutes2 == minutes2;
  }
}

class Route {
  final Set<String> path;
  final int value;
  final int minutes;

  Route({required this.path, required this.value, required this.minutes});
}
