import '../models/graph.dart';

class Auction {
  final Graph graph;
  final double epsilon;
  final Map<Vertex, double> prices = {};
  final Map<Vertex, Vertex?> assignments = {};

  Auction(this.graph, {this.epsilon = 0.01}) {
    if (!graph.isBipartite()) {
      throw ArgumentError(
          'The graph must be bipartite for the auction algorithm.');
    }
    _initialize();
  }

  void _initialize() {
    for (var vertex in graph.vertices.values) {
      prices[vertex] = 0;
      assignments[vertex] = null;
    }
  }

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

          for (var object in buyer.edges.keys) {
            if (objects.contains(object)) {
              double value = buyer.edges[object]! - prices[object]!;
              if (value > bestValue) {
                bestValue = value;
                bestObject = object;
              }
            }
          }

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

    return assignments.entries
        .where((entry) => entry.key.id is int && entry.value != null)
        .map((entry) => [entry.key.id, entry.value!.id])
        .toList();
  }
}
