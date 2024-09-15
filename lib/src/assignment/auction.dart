import '../models/graph.dart';

/// Implements the Auction algorithm for solving assignment problems on bipartite graphs.
///
/// The Auction algorithm is an iterative method for finding the optimal assignment
/// in a weighted bipartite graph. It simulates an auction where "buyers" (one set of vertices)
/// bid for "objects" (the other set of vertices) based on their preferences and prices.
///
/// Visual representation of a bipartite graph:
///
///     Buyers    Objects
///       1  ---- A
///       |  \
///       |   \
///       2  -- B
///       |  \
///       |   \
///       3  ---- C
///
/// Example:
/// Consider a graph with buyers (1, 2, 3) and objects (A, B, C) with the following edge weights:
///
///   1 -- A: 10
///   1 -- B: 12
///   1 -- C: 8
///   2 -- A: 7
///   2 -- B: 8
///   2 -- C: 9
///   3 -- A: 11
///   3 -- B: 9
///   3 -- C: 10
///
/// The Auction algorithm would iteratively assign buyers to objects, aiming to maximize
/// the total value of assignments. The final optimal assignment might be:
///
///   1 -- B (value: 12)
///   2 -- C (value: 9)
///   3 -- A (value: 11)
///
/// This assignment maximizes the total value (12 + 9 + 11 = 32).
class Auction {
  /// The bipartite graph on which the auction algorithm will be performed.
  final Graph graph;

  /// A small positive number used to ensure the algorithm's convergence.
  ///
  /// Smaller values may lead to more accurate results but slower convergence.
  final double epsilon;

  /// Stores the current prices of the objects.
  final Map<Vertex, double> prices = {};

  /// Stores the current assignments of buyers to objects.
  final Map<Vertex, Vertex?> assignments = {};

  /// Creates a new instance of the Auction algorithm.
  ///
  /// [graph] must be a bipartite graph.
  /// [epsilon] is optional and defaults to 0.01.
  ///
  /// Throws an [ArgumentError] if the graph is not bipartite.
  Auction(this.graph, {this.epsilon = 0.01}) {
    if (!graph.isBipartite()) {
      throw ArgumentError(
          'The graph must be bipartite for the auction algorithm.');
    }
    _initialize();
  }

  /// Initializes the prices and assignments for all vertices.
  void _initialize() {
    for (var vertex in graph.vertices.values) {
      prices[vertex] = 0;
      assignments[vertex] = null;
    }
  }

  /// Solves the assignment problem using the Auction algorithm.
  ///
  /// Returns a list of assignments, where each assignment is a list
  /// containing [buyerId, objectId].
  ///
  /// The algorithm iteratively allows unassigned buyers to bid for objects
  /// based on their value and current price. It continues until all buyers
  /// are assigned or no further improvements can be made.
  List<List<dynamic>> solve() {
    List<Vertex> buyers = [];
    List<Vertex> objects = [];

    // Separate vertices into buyers and objects
    for (var vertex in graph.vertices.values) {
      if (vertex.id is int) {
        buyers.add(vertex);
      } else {
        objects.add(vertex);
      }
    }

    bool changed;
    do {
      changed = false;
      for (var buyer in buyers) {
        if (assignments[buyer] == null) {
          var bestValue = double.negativeInfinity;
          Vertex? bestObject;

          // Find the most valuable object for this buyer
          for (var object in buyer.edges.keys) {
            if (objects.contains(object)) {
              double value = buyer.edges[object]! - prices[object]!;
              if (value > bestValue) {
                bestValue = value;
                bestObject = object;
              }
            }
          }

          // Assign the buyer to the best object and update prices
          if (bestObject != null) {
            var oldBuyer = assignments.entries
                .firstWhere((entry) => entry.value == bestObject,
                    orElse: () => MapEntry(buyer, null))
                .key;
            assignments[oldBuyer] = null;
            assignments[buyer] = bestObject;
            prices[bestObject] = prices[bestObject]! + epsilon;
            changed = true;
          }
        }
      }
    } while (changed);

    // Return the final assignments
    return assignments.entries
        .where((entry) => entry.key.id is int && entry.value != null)
        .map((entry) => [entry.key.id, entry.value!.id])
        .toList();
  }
}
