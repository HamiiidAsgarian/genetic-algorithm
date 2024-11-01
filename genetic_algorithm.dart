import 'dart:math';

//#2- Fitness Assignment
const targetAdaptibility =
    42; // Target adaptability for optimal fitness, will be looking for a creature with this Adaptibility

const generationRepeat = 100; // Number of generations to run the algorithm

const mutationChance = 0.01; // Rate of mutation

const initialPopulationSize = 12; // Fixed size for population

final randomSeed = Random();

class Creature {
  int adaptibility;

  Creature({required this.adaptibility});

//#2- Fitness Assignment
  int get fitScore => (targetAdaptibility - adaptibility).abs();

  @override
  String toString() {
    return '(adaptibility: $adaptibility, fitScore: $fitScore)';
  }

  @override
  bool operator ==(Object other) =>
      (other is Creature && this.adaptibility == other.adaptibility);
}

//#1- Determine target value
List<Creature> initPopulation() => List.generate(
    initialPopulationSize,
//#2- Fitness Assignment
    (i) => Creature(adaptibility: randomSeed.nextInt(1000)));

//#3- Selection
List<Creature> selection(List<Creature> population) {
  population.sort((c1, c2) => c1.fitScore.compareTo(c2.fitScore));
  double selectionSize = (population.length / 2);

  List<Creature> bestFits = population.sublist(0, selectionSize.round());

  bestFits.shuffle();
  int totalFitScore1 =
      population.fold(0, (sum, creature) => sum + creature.fitScore);
  print("-- Parents totalFitScore: ${totalFitScore1}");

  return bestFits;
}

//#3- Crossover
List<Creature> crossover(List<Creature> fitPopulation) {
  List<Creature> newGen = [];

  for (int i = 0; i < fitPopulation.length - 1; i += 2) {
    var parent1 = fitPopulation[i];
    var parent2 = fitPopulation[i + 1];

    List<Creature> childeren = [];

    for (var i = 0; i < 4; i++) {
      childeren.add(Creature(
          adaptibility: (parent1.adaptibility + parent2.adaptibility) ~/
              // 2
              (randomSeed.nextInt(4) + 1)));
    }
    newGen.addAll(childeren);
  }
  int totalFitScore =
      newGen.fold(0, (sum, creature) => sum + creature.fitScore);
  print("-- children totalFitScore: ${totalFitScore}");

  return newGen; // Return the new generation
}

//#3- Mutation
List<Creature> mutation(List<Creature> newGeneration) {
  for (var creature in newGeneration) {
    if (randomSeed.nextDouble() < mutationChance) {
      print("↑↑↑ MUTATION: Creature before mutation $creature");
      creature.adaptibility +=
          (randomSeed.nextInt(10) - 5); // Random small change

      creature.adaptibility = creature.adaptibility
          .clamp(0, 100); // Ensure adaptability remains in a valid range
      print("↓↓↓ MUTATION: Creature after mutation $creature");
    }
  }
  return newGeneration;
}

void bigBang() {
  var population = initPopulation();

  for (var i = 0; i < generationRepeat; i++) {
    print(
        "---------------- generation $i / population size = ${population.length}----------------");

    var fitPopulation = selection(population);

    if (fitPopulation.isEmpty) {
      print("No fit population found. Stopping evolution.");
      break;
    }

    var newGeneration = crossover(fitPopulation);
    var newGenerationMutation = mutation(newGeneration);
    population = (newGenerationMutation); // Maintain population size
    print('population members: ${population}');
    ;
    // Check for exact match to targetAdaptibility
    if (population.any((creature) => creature.fitScore == 0)) {
      Creature perfectCreature =
          population.firstWhere((creature) => creature.fitScore == 0);
      print(
          "\n 🌟🌟🌟 Optimal solution found in generation $i!, $perfectCreature 🌟🌟🌟");
      break;
    }
  }
}

void main() {
  bigBang();
}
