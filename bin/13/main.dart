import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  assert(compare(jsonDecode('[1,1,3,1,1]'), jsonDecode('[1,1,5,1,1]')) == -1);
  assert(compare(jsonDecode('[[1],[2,3,4]]'), jsonDecode('[[1],4]')) == -1);
  assert(!(compare(jsonDecode('[9]'), jsonDecode('[[8,7,6]]')) == -1));
  assert(compare(jsonDecode('[[4,4],4,4]'), jsonDecode('[[4,4],4,4,4]')) == -1);
  assert(!(compare(jsonDecode('[7,7,7,7]'), jsonDecode('[7,7,7]')) == -1));
  assert(compare(jsonDecode('[]'), jsonDecode('[3]')) == -1);
  assert(!(compare(jsonDecode('[[[]]]'), jsonDecode('[[]]')) == -1));
  assert(!(compare(jsonDecode('[1,[2,[3,[4,[5,6,7]]]],8,9]'), jsonDecode('[1,[2,[3,[4,[5,6,0]]]],8,9]')) == -1));
  part1('bin/13/test');
  part1('bin/13/input');
  part2('bin/13/test');
  part2('bin/13/input');
}

void part2(String file) {
  var input = File(file).readAsLinesSync().where((element) => element.isNotEmpty).toList()
    ..addAll(['[[2]]', '[[6]]'])
    ..sort((a, b) => compare(jsonDecode(a), jsonDecode(b)));
  final result = (input.indexOf('[[2]]') + 1) * (input.indexOf('[[6]]') + 1);
  print('Part 2: $file: $result');
}

void part1(String file) {
  final input = File(file).readAsLinesSync();
  var left = '', right = '';

  var index = 1;
  var sum = 0;

  for (var line in input) {
    if (line.isNotEmpty) {
      if (left.isEmpty) {
        left = line;
      } else {
        right = line;
      }
      continue;
    }

    if (left != jsonDecode(left).toString().replaceAll(' ', '')) {
      print('left: $left, parsed: ${jsonDecode(left).replaceAll(' ', '')}');
    }
    if (right != jsonDecode(right).toString().replaceAll(' ', '')) {
      print('right: $right, parsed: ${jsonDecode(right).replaceAll(' ', '')}');
    }

    if (compare(jsonDecode(left), jsonDecode(right)) == -1) {
      sum += index;
    }
    index++;
    left = '';
    right = '';
  }

  if (compare(jsonDecode(left), jsonDecode(right)) == -1) {
    sum += index;
  }

  print('Part 1: $file, $sum');
}

int compare(dynamic l, dynamic r) {
  if (l == r) {
    return 0;
  }

  if (l is! List && l is! int) {
    print('l is not a list or int: $l');
  }
  if (r is! List && r is! int) {
    print('r is not a list or int: $r');
  }

  if (l is int && r is int) {
    return l.compareTo(r);
  } else if (l is List && r is List) {
    for (var i = 0; i < min(l.length, r.length); i++) {
      final result = compare(l[i], r[i]);
      if (result != 0) {
        return result;
      }
    }
    return l.length.compareTo(r.length);
  } else {
    if (l is int) {
      return compare([l], r);
    } else {
      return compare(l, [r]);
    }
  }
}
