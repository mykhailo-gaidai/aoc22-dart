import 'dart:io';

main() {
  var lines = File('input/input01').readAsLinesSync();
  List<List<int>> elves = [];
  List<int> elf = [];
  for (var line in lines) {
    if (line.isEmpty) {
      elves.add(elf);
      elf = [];
    } else {
      elf.add(int.parse(line));
    }
  }
  elves.add(elf);

  final sortedElves = elves.map((e) => e.reduce((value, element) => element + value)).toList();
  sortedElves.sort((a, b) => b.compareTo(a));
  print(sortedElves[0] + sortedElves[1] + sortedElves[2]);
}
