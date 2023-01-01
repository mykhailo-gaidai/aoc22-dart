import 'dart:io';

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
  assert(solve1('bin/20/test') == 3);
  print('Part 1: ${solve1('bin/20/input')}');
  // 7735 too low
}

String mix(String input) {
  var list = input.split(',').map(int.parse).toList();
  var result = List.generate(list.length, (index) => index);

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

  return result.map((e) => list[e]).join(',');
}

int solve1(String filename) {
  var input = File(filename).readAsLinesSync().join(',');
  var mixed = mix(input).split(',').map(int.parse).toList();

  var indexOf0 = mixed.indexOf(0);
  var itemAt1000 = mixed[(indexOf0 + 1000) % (mixed.length)];
  var itemAt2000 = mixed[(indexOf0 + 2000) % mixed.length];
  var itemAt3000 = mixed[(indexOf0 + 3000) % mixed.length];
  var coord = itemAt1000 + itemAt2000 + itemAt3000;

  return coord;
}
