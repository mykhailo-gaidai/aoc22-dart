import 'dart:io';

import '../18/main.dart';

void main() {
  assert(mix('1,0,0') == '0,1,0');
  assert(mix('2,0,0') == '0,0,2');
  assert(mix('3,0,0') == '0,3,0');
  assert(mix('-1,0,0') == '0,-1,0');
  assert(mix('-2,0,0') == '0,0,-2');
  assert(mix('0,1,0') == '0,0,1');
  assert(mix('0,2,0') == '0,2,0');
  assert(mix('0,-1,0') == '0,0,-1');
  assert(mix('0,-2,0') == '0,-2,0');
  assert(mix('0,-2,0,0,0,0,0') == '0,0,0,0,0,-2,0');
  assert(mix('0,0,1') == '0,1,0');
  assert(mix('0,0,2') == '0,0,2');
  assert(mix('0,0,-1') == '0,-1,0');
  assert(mix('0,0,-2') == '0,0,-2');
  assert(solve('bin/20/test') == 3);
  assert(solve('bin/20/input') == 8302);
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 0, decryptionKey: 811589153) ==
      '811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 1, decryptionKey: 811589153) ==
      '0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 2, decryptionKey: 811589153) ==
      '0, 2434767459, 1623178306, 3246356612, -2434767459, -1623178306, 811589153');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 3, decryptionKey: 811589153) ==
      '0, 811589153, 2434767459, 3246356612, 1623178306, -1623178306, -2434767459');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 4, decryptionKey: 811589153) ==
      '0, 1623178306, -2434767459, 811589153, 2434767459, 3246356612, -1623178306');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 5, decryptionKey: 811589153) ==
      '0, 811589153, -1623178306, 1623178306, -2434767459, 3246356612, 2434767459');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 6, decryptionKey: 811589153) ==
      '0, 811589153, -1623178306, 3246356612, -2434767459, 1623178306, 2434767459');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 7, decryptionKey: 811589153) ==
      '0, -2434767459, 2434767459, 1623178306, -1623178306, 811589153, 3246356612');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 8, decryptionKey: 811589153) ==
      '0, 1623178306, 3246356612, 811589153, -2434767459, 2434767459, -1623178306');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 9, decryptionKey: 811589153) ==
      '0, 811589153, 1623178306, -2434767459, 3246356612, 2434767459, -1623178306');
  assert(mix('1, 2, -3, 3, -2, 0, 4', delimiter: ', ', times: 10, decryptionKey: 811589153) ==
      '0, -2434767459, 1623178306, 3246356612, -1623178306, 2434767459, 811589153');
  assert(solve('bin/20/test', times: 10, decryptionKey: 811589153) == 1623178306);
  print('part 2: ${solve('bin/20/input', times: 10, decryptionKey: 811589153)}');
}

String mix(String input, {String delimiter = ',', int times = 1, int decryptionKey = 1}) {
  var list = input.split(delimiter).map((e) => int.parse(e) * decryptionKey).toList();
  var result = List.generate(list.length, (index) => index);

  for (var i = 0; i < times; i++) {
    for (var i = 0; i < list.length; i++) {
      var delta = list[i];
      if (delta == 0) continue;
      var index = result.indexOf(i);
      result.removeAt(index);
      var newIndex = (index + delta) % result.length;
      if (newIndex == 0) {
        result.add(i);
      } else {
        result.insert(newIndex, i);
      }
    }
  }

  return result.map((e) => list[e]).join(delimiter);
}

int solve(String filename, {int times = 1, int decryptionKey = 1}) {
  var input = File(filename).readAsLinesSync().join(',');
  var mixed = mix(input, times: times, decryptionKey: decryptionKey).split(',').map(int.parse).toList();

  var indexOf0 = mixed.indexOf(0);
  var itemAt1000 = mixed[(indexOf0 + 1000) % (mixed.length)];
  var itemAt2000 = mixed[(indexOf0 + 2000) % mixed.length];
  var itemAt3000 = mixed[(indexOf0 + 3000) % mixed.length];
  var coord = itemAt1000 + itemAt2000 + itemAt3000;

  return coord;
}
