import 'dart:io';

void main() {
  part1('bin/07/test');
  part1('bin/07/input');
  part2('bin/07/test');
  part2('bin/07/input');
}

void part1(String file) {
  var folderSizes = {
    '/': 0,
  };
  var path = '/';

  // read file by lines
  final input = File(file).readAsLinesSync();
  // go through all the lines
  for (var line in input) {
    var split = line.split(' ');

    if (split[0] == 'dir' || (split[0] == '\$' && split[1] == 'ls')) {
      continue;
    } else if (split[0] == '\$' && split[1] == 'cd') {
      final newFolder = split[2];
      switch (newFolder) {
        case '/':
          path = '/';
          break;
        case '..':
          path = path.substring(0, path.lastIndexOf('/'));
          break;
        default:
          path += '/$newFolder';
          break;
      }
    } else {
      final fileSize = int.parse(split[0]);
      folderSizes[path] = (folderSizes[path] ?? 0) + fileSize;
      var temp = path;
      // add file size to all parent folders
      while (temp != '/') {
        temp = temp.substring(0, temp.lastIndexOf('/'));
        folderSizes[temp] = (folderSizes[temp] ?? 0) + fileSize;
      }
    }
  }

  final totalSize = folderSizes.entries
      .where((element) => element.value < 100000)
      .fold(0, (previousValue, element) => previousValue + element.value);
  print('part1: totalSize: $totalSize');
}

void part2(String file) {
  var folderSizes = {
    '/': 0,
  };
  var path = '/';

  // read file by lines
  final input = File(file).readAsLinesSync();
  // go through all the lines
  for (var line in input) {
    var split = line.split(' ');

    if (split[0] == 'dir' || (split[0] == '\$' && split[1] == 'ls')) {
      continue;
    } else if (split[0] == '\$' && split[1] == 'cd') {
      final newFolder = split[2];
      switch (newFolder) {
        case '/':
          path = '/';
          break;
        case '..':
          path = path.substring(0, path.lastIndexOf('/'));
          break;
        default:
          path += '/$newFolder';
          break;
      }
    } else {
      final fileSize = int.parse(split[0]);
      folderSizes[path] = (folderSizes[path] ?? 0) + fileSize;
      var temp = path;
      // add file size to all parent folders
      while (temp != '/') {
        temp = temp.substring(0, temp.lastIndexOf('/'));
        folderSizes[temp] = (folderSizes[temp] ?? 0) + fileSize;
      }
    }
  }

  final required = 30000000 - (70000000 - folderSizes['/']!);
  print('required: $required');
  var list = folderSizes.entries.where((element) => element.value >= required).toList();
  list.sort((a, b) => a.value.compareTo(b.value));
  print('part2: $file: ${list.first.value}');
}
