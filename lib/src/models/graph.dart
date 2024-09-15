/// Represents a vertex in a graph.
class Vertex {
  /// The unique identifier for this vertex.
  final dynamic id;

  /// A map of adjacent vertices and their edge weights.
  Map<Vertex, double> edges = {};

  /// Creates a new [Vertex] with the given [id].
  Vertex(this.id);

  /// Adds an edge from this vertex to another vertex.
  ///
  /// [to] is the destination vertex.
  /// [weight] is the weight of the edge.
  void addEdge(Vertex to, double weight) {
    edges[to] = weight;
  }

  @override
  String toString() => 'Vertex($id)';
}

/// Represents a graph data structure.
///
/// This class implements a graph with vertices and edges. It can be either
/// directed or undirected, as specified by the [isDirected] parameter.
class Graph {
  /// A map of vertex IDs to their corresponding [Vertex] objects.
  final Map<dynamic, Vertex> vertices = {};

  /// Indicates whether the graph is directed (true) or undirected (false).
  bool isDirected;

  /// Creates a new [Graph] instance.
  ///
  /// [isDirected] determines whether the graph is directed or undirected.
  /// By default, the graph is undirected (false).
  Graph({this.isDirected = false});

  /// Adds a new vertex to the graph with the given [id].
  ///
  /// If a vertex with the same [id] already exists, it will not be added again.
  void addVertex(dynamic id) {
    if (!vertices.containsKey(id)) {
      vertices[id] = Vertex(id);
    }
  }

  /// Adds an edge between two vertices in the graph.
  ///
  /// [from] is the ID of the source vertex.
  /// [to] is the ID of the destination vertex.
  /// [weight] is the weight of the edge.
  ///
  /// If the vertices don't exist, they will be added to the graph.
  /// For undirected graphs, an edge is added in both directions.
  ///
  /// Throws an [ArgumentError] if the vertices are not found in the graph.
  void addEdge(dynamic from, dynamic to, double weight) {
    addVertex(from);
    addVertex(to);
    final fromVertex = vertices[from];
    final toVertex = vertices[to];
    if (fromVertex == null || toVertex == null) {
      throw ArgumentError('Vertices not found in the graph');
    }
    fromVertex.addEdge(toVertex, weight);
    if (!isDirected) {
      toVertex.addEdge(fromVertex, weight);
    }
  }

  /// Returns a list of all vertices in the graph.
  ///
  /// The order of vertices in the list is not guaranteed.
  List<Vertex> getVertices() => vertices.values.toList();

  /// Returns a list of all edges in the graph.
  ///
  /// Each edge is represented as a list containing:
  /// [sourceVertexId, destinationVertexId, edgeWeight]
  ///
  /// For undirected graphs, each edge will appear twice in opposite directions.
  List<List<dynamic>> getEdges() {
    List<List<dynamic>> edges = [];
    for (var vertex in vertices.values) {
      for (var edge in vertex.edges.entries) {
        edges.add([vertex.id, edge.key.id, edge.value]);
      }
    }
    return edges;
  }

  /// Checks if the graph is bipartite.
  ///
  /// A graph is bipartite if its vertices can be divided into two disjoint sets
  /// such that every edge connects a vertex in one set to a vertex in the other set.
  ///
  /// Returns true if the graph is bipartite, false otherwise.
  bool isBipartite() {
    Map<Vertex, String> color = {};

    bool dfsColorCheck(Vertex vertex, String currentColor) {
      color[vertex] = currentColor;
      String nextColor = (currentColor == 'red') ? 'blue' : 'red';

      for (var neighbor in vertex.edges.keys) {
        if (!color.containsKey(neighbor)) {
          if (!dfsColorCheck(neighbor, nextColor)) {
            return false;
          }
        } else if (color[neighbor] == currentColor) {
          return false;
        }
      }
      return true;
    }

    for (var vertex in vertices.values) {
      if (!color.containsKey(vertex)) {
        if (!dfsColorCheck(vertex, 'red')) {
          return false;
        }
      }
    }
    return true;
  }
}
