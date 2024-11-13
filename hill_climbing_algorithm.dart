import 'dart:math';

// the hill function
double objectiveFunction(double x) {
  return (3 * exp(-pow(x - 3, 2) / 0.5) +
      6 * exp(-pow(x - 6, 2) / 0.5) +
      9 * exp(-pow(x - 9, 2) / 0.5) +
      0.5);
}

(double, double)? hillClimbing() {
  var randomInit = (Random().nextInt(10))
      .toDouble(); //1 - random double value between 1 to 10

  print('starting point is $randomInit');
  var currentPoint = randomInit;
  var stepSize = 0.1;

  var foundHillPeak = false;

  while (!foundHillPeak) {
    print(
        '\n --------------------- point: $currentPoint----------------------- \n');

// determine left and right neighbors
    var leftNeighbor = currentPoint - stepSize;
    var rightNeighbor = currentPoint + stepSize;

// find the values of current, left and right neighbors on the function
    final currentNeighborOnGraph = objectiveFunction(currentPoint);

    final leftNeighborOnGraph = objectiveFunction(leftNeighbor);
    final rightNeighborOnGraph = objectiveFunction(rightNeighbor);

    print(
        'current is $currentNeighborOnGraph and left is $leftNeighborOnGraph and right is $rightNeighborOnGraph');

    if (leftNeighborOnGraph < currentNeighborOnGraph &&
        rightNeighborOnGraph < currentNeighborOnGraph) {
      foundHillPeak = true;
      print(
          '⭐⭐⭐ The top has been found on value $currentPoint on the graph: $currentNeighborOnGraph ⭐⭐⭐');
      return (currentPoint, currentNeighborOnGraph);
    }

//pick the climbing neighbor as the currentPoint
    if (leftNeighborOnGraph > rightNeighborOnGraph) {
      currentPoint = leftNeighbor;
      print('--- $currentPoint moving left !!!!!');
    } else {
      currentPoint = rightNeighbor;
      print('--- $currentPoint moving rigth !!!!!');
    }
  }
  return null;
}

void main() {
  int numberOfTries = 10;
  List<Map<double, double>> achievedHillPeaks = [];

  List<double> localMaximas = [];

  for (var i = 0; i < numberOfTries; i++) {
    var currentHillPeakValue = hillClimbing();
    var roundedValue =
        double.parse(currentHillPeakValue!.$2.toString().substring(0, 4));

    achievedHillPeaks.add({currentHillPeakValue.$1: roundedValue});
    localMaximas.add(roundedValue);
  }
  List sortedByValue = achievedHillPeaks.toList()
    ..sort((a, b) => a.values.first.compareTo(b.values.first));

  localMaximas.sort();

  print('\n local maxima: ${localMaximas.toSet()}');

  print(
      '\n Global maxima: on point ${sortedByValue.last.keys.first} with value ${sortedByValue.last.values.first}');
}