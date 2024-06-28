import 'dart:math';

const int NUM_COLOURS = 6;
const int CODE_LENGTH = 4;

List<List<int>> combinations = [];
List<List<int>> candidateSolutions = [];
List<List<int>> nextGuesses = [];
List<int> code = [];
List<int> currentGuess = [];
String responsePegs = '';
bool won = false;
int turn = 1;

void main() {
  turn = 1;
  won = false;

  code = getRandomCode();
  currentGuess = [1, 1, 2, 2]; // 1122

  // Create the set of 1296 possible codes
  createSet();
  candidateSolutions.addAll(combinations);

  print('Code: ${code.join(' ')}');

  while (!won) {
    // Remove currentGuess from possible solutions
    removeCode(combinations, currentGuess);
    removeCode(candidateSolutions, currentGuess);

    // Play the guess to get a response of colored and white pegs
    responsePegs = checkCode(currentGuess, code);

    print('Turn: $turn');
    print('Guess: ${currentGuess.join(' ')} = $responsePegs');

    // If the response is four colored pegs, the game is won
    if (responsePegs == 'BBBB') {
      won = true;
      print('Game Won!');
      break;
    }

    // Remove from candidateSolutions, any code that would not give the same response if it were the code
    pruneCodes(candidateSolutions, currentGuess, responsePegs);

    // Calculate Minmax scores
    nextGuesses = minmax();

    // Select next guess
    currentGuess = getNextGuess(nextGuesses);

    turn++;
  }
}

List<int> getRandomCode() {
  List<int> code = [];
  Random rand = Random();

  for (int i = 0; i < CODE_LENGTH; i++) {
    int random = 1 + rand.nextInt(NUM_COLOURS);
    code.add(random);
  }

  return code;
}

void createSet() {
  List<int> current = List.filled(CODE_LENGTH, 0);
  List<int> elements = List.generate(NUM_COLOURS, (i) => i + 1);

  combinationRecursive(CODE_LENGTH, 0, current, elements);
}

void combinationRecursive(int combinationLength, int position,
    List<int> current, List<int> elements) {
  if (position >= combinationLength) {
    combinations.add(List.from(current));
    return;
  }

  for (int j = 0; j < elements.length; j++) {
    current[position] = elements[j];
    combinationRecursive(combinationLength, position + 1, current, elements);
  }
}

String checkCode(List<int> guess, List<int> code) {
  String result = '';
  List<int> tempGuess = List.from(guess);
  List<int> tempCode = List.from(code);

  // Get black/colored pegs
  for (int i = 0; i < CODE_LENGTH; i++) {
    if (tempGuess[i] == tempCode[i]) {
      result += 'B';
      tempGuess[i] = -1;
      tempCode[i] = -1;
    }
  }

  // Get white pegs
  for (int i = 0; i < CODE_LENGTH; i++) {
    if (tempCode[i] > 0) {
      int index = tempGuess.indexOf(tempCode[i]);
      if (index != -1) {
        result += 'W';
        tempGuess[index] = -1;
      }
    }
  }

  return result;
}

void removeCode(List<List<int>> set, List<int> currentCode) {
  set.remove(currentCode);
}

void pruneCodes(
    List<List<int>> set, List<int> currentCode, String currentResponse) {
  set.removeWhere((code) => checkCode(currentCode, code) != currentResponse);
}

List<List<int>> minmax() {
  Map<String, int> scoreCount = {};
  Map<List<int>, int> score = {};
  List<List<int>> nextGuesses = [];
  int _max, _min;

  for (List<int> combination in combinations) {
    for (List<int> candidate in candidateSolutions) {
      String pegScore = checkCode(combination, candidate);
      scoreCount.update(pegScore, (v) => v + 1, ifAbsent: () => 1);
    }

   _max = scoreCount.values.reduce(max);
    score[combination] = _max;
    scoreCount.clear();
  }

  _min = score.values.reduce(min);

  score.forEach((key, value) {
    if (value == _min) {
      nextGuesses.add(key);
    }
  });

  return nextGuesses;
}

int getMaxScore(Map<String, int> inputMap) {
  return inputMap.values.reduce(max);
}

int getMinScore(Map<List<int>, int> inputMap) {
  return inputMap.values.reduce(min);
}

List<int> getNextGuess(List<List<int>> nextGuesses) {
  for (List<int> guess in nextGuesses) {
    if (candidateSolutions.contains(guess)) {
      return guess;
    }
  }
  for (List<int> guess in nextGuesses) {
    if (combinations.contains(guess)) {
      return guess;
    }
  }
  return [];
}
