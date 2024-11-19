import 'dart:math';

class Whale {
  double _position;
  double _fitness;

  Whale({required double position})
      : _position = position,
        _fitness = _calculateFitness(position);

  double get position => _position;
  double get fitness => _fitness;

  set position(double newPosition) {
    _position = newPosition;
    _fitness = _calculateFitness(newPosition);
  }

// three peaks hill graph ==> https://www.desmos.com/calculator/gmqy87jgba
  static double _calculateFitness(double x) {
    return (3 * exp(-pow(x - 3, 2) / 0.5) +
        6 * exp(-pow(x - 6, 2) / 0.5) +
        9 * exp(-pow(x - 9, 2) / 0.5) +
        0.5);
  }
}

// Whale Optimization Algorithm
void whaleOptimizationAlgorithm({
  required int populationSize, // whales count
  required int maxIterations, // times whales try
  required double minX, // Search space lower bound
  required double maxX, // Search space upper bound
}) {
  print('Hamiiid'); //Signiture

  // Initialize population in random positions within the range (and fitness)
  List<Whale> whales = List.generate(populationSize, (_) {
    var randomPosition = Random().nextDouble() * (maxX - minX) + minX;
    return Whale(
      position: randomPosition,
    );
  });

  // Find the best whale (prey)
  Whale bestWhale = whales.reduce((a, b) => a.fitness > b.fitness ? a : b);

  // Optimization loop
  for (int iter = 0; iter < maxIterations; iter++) {
    for (int i = 0; i < populationSize; i++) {
      //a: Linearly decreases from 2.0 to 0 over the course of iterations.
      //Why?: As a decreases, the whales shift from exploration (random searching) to exploitation (fine-tuning near the best solution).
      final a = 2.0 - iter * (2.0 / maxIterations);
      final r = Random().nextDouble();
      //A: A coefficient that controls the magnitude and direction of a whale's movement.
      //It depends on a and random factors, so it decreases as iterations progress.
      final A = 2 * a * r - a;
      //C: A coefficient that helps control the "encircling" behavior of the whales around the best solution.
      final C = 2 * r;

      // Exploration phase
      //This randomly decides whether the whale will enter the exploration phase or the exploitation phase.
      if (Random().nextDouble() < 0.5) {
        double D = (C * bestWhale.position - whales[i].position).abs();
        //Position Update:
        //The whale moves away from or toward the best solution based on the value of A.
        //If A > 1, the whale explores further away from the best solution.
        //If A < 1, the whale moves closer to the best solution.
        //Key Idea: The exploration phase allows the whales to search the space broadly for other promising areas.
        whales[i].position = bestWhale.position - A * D;
      } else {
        // Exploitation phase
        //D: The absolute difference between the whale's position and the bestWhale position, scaled by the coefficient C.
        double D = (bestWhale.position - whales[i].position).abs();
        //A random number in the range [-1, 1], representing a "spiral factor."
        double l = Random().nextDouble() * 2 - 1;
        //b: A constant controlling the tightness of the spiral.
        double b = 1;
        //Position Update:
        //The whale’s position is updated to follow a spiral path around the bestWhale.
        //This simulates the "bubble-net" feeding behavior of humpback whales, converging tightly around the best solution.
        //Key Idea: The exploitation phase fine-tunes the search near the best solution using a spiral trajectory.
        whales[i].position =
            D * exp(b * l) * cos(2 * pi * l) + bestWhale.position;
      }

      // Position clamping
      whales[i].position = whales[i].position.clamp(minX, maxX);

      // Update the best whale
      if (whales[i].fitness > bestWhale.fitness) {
        bestWhale = whales[i];
      }
    }

    // Output the best fitness value at each iteration
    print(
        "Iteration $iter: Best Fitness = ${bestWhale.fitness} at x = ${bestWhale.position}");
  }

  // Output the final result
  print(
      "Optimal solution found: x = ${bestWhale.position}, f(x) = ${bestWhale.fitness}");
}

void main() {
  whaleOptimizationAlgorithm(
      populationSize: 10, maxIterations: 50, minX: 0, maxX: 10);
}
