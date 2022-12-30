import 'dart:io';
import 'dart:math';

final maxMinutes = 24;

void main() {
  var testBlueprints = readBlueprints('bin/19/test');
  var blueprints = readBlueprints('bin/19/input');
  print('part1, test, ${solve1(testBlueprints)}');
  print('part1, test, ${solve1(blueprints)}');
}

var cache = <State, State>{};

int findMaxGeodes(Blueprint blueprint) {
  var initialState = State(blueprint);
  var current = initialState;
  current = current.bestBuildClayRobot();
  current = current.bestBuildObsidianRobot();
  current = current.bestBuildGeodeRobot();

  while (true) {
    var temp = current.bestBuildGeodeRobot();
    if (temp.minutesPassed < maxMinutes) {
      current = temp;
    } else {
      break;
    }
  }
  current = current.step(maxMinutes - current.minutesPassed);

  return current.resources.last;
}

int solve1DFS(State state) {

  if (state.minutesPassed == maxMinutes) {
    return state.resources.last;
  }

  var options = <State>[];
  if (state.robots[0] < state.blueprint.maxOre) {
    options.add(state.buildOreRobot());
  }
  if (state.robots[1] < state.blueprint.maxClay) {
    options.add(state.buildClayRobot());
  }
  if (state.robots[1] > 0 && state.robots[2] < state.blueprint.maxObsidian) {
    options.add(state.buildObsidianRobot());
  }
  if (state.robots[2] > 0) {
    options.add(state.buildGeodeRobot());
  }

  var outcomes = options.where((element) => element.minutesPassed <= maxMinutes).map((e) => solve1DFS(e));
  if (outcomes.isEmpty) {
    return state.resources.last + (maxMinutes - state.minutesPassed) * state.robots.last;
  }
  var bestOutcome = outcomes.reduce((value, element) => value > element ? value : element);

  return bestOutcome;
}

int solve1(List<Blueprint> blueprints) {
  var result = 0;
  for (var b in blueprints) {
    // result += findMaxGeodes(b) * b.index;
    result += solve1DFS(State(b)) * b.index;
  }
  return result;
}

List<Blueprint> readBlueprints(String filename) =>
    File(filename).readAsLinesSync().map((e) => Blueprint.fromString(e)).toList();

class State {
  final Blueprint blueprint;
  final List<int> resources;
  final List<int> robots;
  final int minutesPassed;

  State(this.blueprint,
      {this.resources = const [0, 0, 0, 0], this.robots = const [1, 0, 0, 0], this.minutesPassed = 0});

  State clone() => State(blueprint, resources: [...resources], robots: [...robots], minutesPassed: minutesPassed);

  int minutesToBuildAnotherOreRobot() => max(((blueprint.oreRobotCost - resources[0]) / robots[0]).ceil(), 0);

  int minutesToBuildAnotherClayRobot() => max(((blueprint.clayRobotCost - resources[0]) / robots[0]).ceil(), 0);

  int minutesToBuildAnotherObsidianRobot() => max(
      max(((blueprint.obsidianRobotOreCost - resources[0]) / robots[0]).ceil(),
          ((blueprint.obsidianRobotClayCost - resources[1]) / robots[1]).ceil()),
      0);

  int minutesToBuildAnotherGeodeRobot() => max(
      max(((blueprint.geodeRobotObsidianCost - resources[2]) / robots[2]).ceil(),
          ((blueprint.geodeRobotOreCost - resources[0]) / robots[0]).ceil()),
      0);

  State step([int times = 1]) {
    var tempResources = [...resources];
    for (var i = 0; i < times; i++) {
      for (var j = 0; j < tempResources.length; j++) {
        tempResources[j] += robots[j];
      }
    }
    return State(
      blueprint,
      resources: tempResources,
      robots: robots,
      minutesPassed: minutesPassed + times,
    );
  }

  State buildOreRobot() {
    var tempState = step(minutesToBuildAnotherOreRobot() + 1);

    var tempResources = [...tempState.resources];
    var tempRobots = [...tempState.robots];
    tempResources[0] -= blueprint.oreRobotCost;
    tempRobots[0]++;

    return State(blueprint, resources: tempResources, robots: tempRobots, minutesPassed: tempState.minutesPassed);
  }

  State bestBuildClayRobot() {
    var current = this;
    while (true) {
      var temp = current.buildOreRobot();
      var minutesNow = temp.minutesPassed + temp.minutesToBuildAnotherClayRobot();
      var minutesBefore = current.minutesPassed + current.minutesToBuildAnotherClayRobot();
      if (minutesNow <= minutesBefore) {
        current = temp;
      } else {
        break;
      }
    }
    return current.buildClayRobot();
  }

  State bestBuildObsidianRobot() {
    var current = this;
    while (true) {
      var oreMinutes = ((blueprint.obsidianRobotOreCost - current.resources[0]) / current.robots[0]).ceil();
      var clayMinutes = ((blueprint.obsidianRobotClayCost - current.resources[1]) / current.robots[1]).ceil();
      State temp;
      if (oreMinutes == clayMinutes) {
        break;
      } else if (oreMinutes > clayMinutes) {
        temp = current.buildOreRobot();
      } else {
        temp = current.bestBuildClayRobot();
      }

      var minutesNow = temp.minutesPassed + temp.minutesToBuildAnotherObsidianRobot();
      var minutesBefore = current.minutesPassed + current.minutesToBuildAnotherObsidianRobot();
      if (minutesNow <= minutesBefore) {
        current = temp;
      } else {
        break;
      }
    }
    return current.buildObsidianRobot();
  }

  State bestBuildGeodeRobot() {
    var current = this;
    while (true) {
      var oreMinutes = ((blueprint.geodeRobotOreCost - current.resources[0]) / current.robots[0]).ceil();
      var obsidianMinutes = ((blueprint.geodeRobotObsidianCost - current.resources[2]) / current.robots[2]).ceil();
      State temp;
      if (oreMinutes == obsidianMinutes) {
        break;
      } else if (oreMinutes > obsidianMinutes) {
        temp = current.buildOreRobot();
      } else {
        temp = current.bestBuildObsidianRobot();
      }

      var minutesNow = temp.minutesPassed + temp.minutesToBuildAnotherGeodeRobot();
      var minutesBefore = current.minutesPassed + current.minutesToBuildAnotherGeodeRobot();
      if (minutesNow <= minutesBefore) {
        current = temp;
      } else {
        break;
      }
    }
    return current.buildGeodeRobot();
  }

  State buildClayRobot() {
    var tempState = step(minutesToBuildAnotherClayRobot() + 1);

    var tempResources = [...tempState.resources];
    var tempRobots = [...tempState.robots];
    tempResources[0] -= blueprint.clayRobotCost;
    tempRobots[1]++;

    return State(blueprint, resources: tempResources, robots: tempRobots, minutesPassed: tempState.minutesPassed);
  }

  State buildObsidianRobot() {
    var tempState = step(minutesToBuildAnotherObsidianRobot() + 1);

    var tempResources = [...tempState.resources];
    var tempRobots = [...tempState.robots];
    tempResources[0] -= blueprint.obsidianRobotOreCost;
    tempResources[1] -= blueprint.obsidianRobotClayCost;
    tempRobots[2]++;

    return State(blueprint, resources: tempResources, robots: tempRobots, minutesPassed: tempState.minutesPassed);
  }

  State buildGeodeRobot() {
    var tempState = step(minutesToBuildAnotherGeodeRobot() + 1);

    var tempResources = [...tempState.resources];
    var tempRobots = [...tempState.robots];
    tempResources[0] -= blueprint.geodeRobotOreCost;
    tempResources[2] -= blueprint.geodeRobotObsidianCost;
    tempRobots[3]++;

    return State(blueprint, resources: tempResources, robots: tempRobots, minutesPassed: tempState.minutesPassed);
  }

  @override
  String toString() {
    return '{robots: ${robots.join(', ')}, resources: ${resources.join(', ')}, minutesPassed: $minutesPassed}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is State &&
        other.blueprint == blueprint &&
        other.resources[0] == resources[0] &&
        other.resources[1] == resources[1] &&
        other.resources[2] == resources[2] &&
        other.resources[3] == resources[3] &&
        other.robots[0] == robots[0] &&
        other.robots[1] == robots[1] &&
        other.robots[2] == robots[2] &&
        other.robots[3] == robots[3] &&
        other.minutesPassed == minutesPassed;
  }

  @override
  int get hashCode =>
      blueprint.hashCode ^
      resources[0].hashCode ^
      resources[1].hashCode ^
      resources[2].hashCode ^
      resources[3].hashCode ^
      robots[0].hashCode ^
      robots[1].hashCode ^
      robots[2].hashCode ^
      robots[3].hashCode ^
      minutesPassed.hashCode;
}

class Blueprint {
  final int index;
  final int oreRobotCost;
  final int clayRobotCost;
  final int obsidianRobotOreCost;
  final int obsidianRobotClayCost;
  final int geodeRobotOreCost;
  final int geodeRobotObsidianCost;
  final int maxOre;
  final int maxClay;
  final int maxObsidian;

  Blueprint({
    required this.index,
    required this.oreRobotCost,
    required this.clayRobotCost,
    required this.obsidianRobotOreCost,
    required this.obsidianRobotClayCost,
    required this.geodeRobotOreCost,
    required this.geodeRobotObsidianCost,
  })  : maxOre = max(oreRobotCost, max(clayRobotCost, max(obsidianRobotOreCost, geodeRobotOreCost))),
        maxClay = obsidianRobotClayCost,
        maxObsidian = geodeRobotObsidianCost;

  factory Blueprint.fromString(String string) {
    var split = string.split(' ');
    return Blueprint(
      index: int.parse(split[1].replaceAll(':', '')),
      oreRobotCost: int.parse(split[6]),
      clayRobotCost: int.parse(split[12]),
      obsidianRobotOreCost: int.parse(split[18]),
      obsidianRobotClayCost: int.parse(split[21]),
      geodeRobotOreCost: int.parse(split[27]),
      geodeRobotObsidianCost: int.parse(split[30]),
    );
  }
}
