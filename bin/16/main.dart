import 'dart:io';

void main() {
  // part1('bin/16/test');
  part1('bin/16/input');
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

  final openable = input.where((element) => element[1] != '0').map((e) => e[0]).toList();
  var routes = openable.map((e) => ['AA', e]).toList();
  for (var i = 0; i < openable.length - 1; i++) {
    for (var j = i + 1; j < openable.length; j++) {
      routes.add([openable[i], openable[j]]);
    }
  }
  routes = routes.map((e) => [e[0], e[1], distance(from: e[0] as String, to: e[1] as String)]).toList();

  final variants = openable.length + List.generate(openable.length, (index) => index +1).reduce((value, element) => value * element);
  var maxMinutes = 30;

  var counter = 0;
  Route getBestRoute(Route route) {
    if (route.minutes >= maxMinutes) return route;

    var last = route.path.last;
    var possibleRoutes = routes.where((element) {
      return (element[0] == last && element[1] != 'AA') || element[1] == last && element[0] != 'AA';
    }).where((element) {
      final destination = element[0] == last ? element[1] : element[0];
      return !route.path.contains(destination);
    }).toList();
    if (possibleRoutes.isEmpty) {
      return route;
    }
    var newRoutes = possibleRoutes.map((e) {
      final dest = e[0] == last ? e[1] : e[0];
      final distance = (e[2] as int) + 1;
      final newPath = {...route.path, dest as String};
      final newMinutes = route.minutes + distance;
      final pressure = int.parse(input.firstWhere((element) => element[0] == dest)[1] as String);
      final newValue = newMinutes >= maxMinutes ? route.value : route.value + (maxMinutes - newMinutes) * pressure;

      return getBestRoute(Route(path: newPath, minutes: newMinutes, value: newValue));
    }).toList()..sort((a, b) => b.value.compareTo(a.value));
    return newRoutes.first;
  }

  final bestRoute = getBestRoute(Route(path: {'AA'}, minutes: 0, value: 0));
  print('part1, $file, ${bestRoute.value}');
}

class Route {
  final Set<String> path;
  final int value;
  final int minutes;

  Route({required this.path, required this.value, required this.minutes});
}
