import 'dart:io';

void main() {
  part1();
  part2('input/02/test');
  part2('input/02/input');
}

enum Move {
  rock, paper, scissors;
}

void part1() {
  var score = 0;
  File('input/02/input').readAsLinesSync().forEach((line) {
    var split = line.split(' ');
    // A for Rock, B for Paper, and C for Scissors
    var opponent = split[0] == 'A' ? Move.rock : split[0] == 'B' ? Move.paper : Move.scissors;
    // X for Rock, Y for Paper, and Z for Scissors
    var you = split[1] == 'X' ? Move.rock : split[1] == 'Y' ? Move.paper : Move.scissors;
    // (1 for Rock, 2 for Paper, and 3 for Scissors)
    switch(you) {
      case Move.rock:
        score +=1;
        break;
      case Move.paper:
        score +=2;
        break;
      case Move.scissors:
        score +=3;
        break;
    }
    // (0 if you lost, 3 if the round was a draw, and 6 if you won)
    switch (opponent) {
      case Move.rock:
        score += you == Move.rock ? 3 : you == Move.paper ? 6 : 0;
        break;
      case Move.paper:
        score += you == Move.paper ? 3 : you == Move.scissors ? 6 : 0;
        break;
      case Move.scissors:
        score += you == Move.scissors ? 3 : you == Move.rock ? 6 : 0;
        break;
    }
  });
  print('part1 score = $score');
}

void part2(String inputFile) {
  var score = 0;
  File(inputFile).readAsLinesSync().forEach((line) {
    var split = line.split(' ');
    // A for Rock, B for Paper, and C for Scissors
    var opponent = split[0] == 'A' ? Move.rock : split[0] == 'B' ? Move.paper : Move.scissors;
    var you = split[1];
    // X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win
    score += you == 'X' ? 0 : you == 'Y' ? 3 : 6;
    // (1 for Rock, 2 for Paper, and 3 for Scissors)
    switch (opponent) {
      case Move.rock:
        score += you == 'X' ? 3 : you == 'Y' ? 1 : 2;
        break;
      case Move.paper:
        score += you == 'X' ? 1 : you == 'Y' ? 2 : 3;
        break;
      case Move.scissors:
        score += you == 'X' ? 2 : you == 'Y' ? 3 : 1;
        break;
    }
  });
  print('part2 score = $score');
}

