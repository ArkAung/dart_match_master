import 'package:test/test.dart';
import 'package:dart_match_master/src/models/graph.dart';

void main() {
  group('Vertex', () {
    test('creation and toString', () {
      final vertex = Vertex(1);
      expect(vertex.id, equals(1));
      expect(vertex.toString(), equals('Vertex(1)'));
    });

    test('addEdge', () {
      final vertex1 = Vertex(1);
      final vertex2 = Vertex(2);
      vertex1.addEdge(vertex2, 5.0);
      expect(vertex1.edges[vertex2], equals(5.0));
    });
  });

  group('Graph', () {
    late Graph graph;

    setUp(() {
      graph = Graph();
    });

    test('should create an empty graph', () {
      expect(graph.vertices, isEmpty);
      expect(graph.isDirected, isFalse);
    });

    test('should add vertices', () {
      graph.addVertex(1);
      graph.addVertex(2);
      graph.addVertex(3);

      expect(graph.vertices.length, equals(3));
      expect(graph.vertices.keys, containsAll([1, 2, 3]));
    });

    test('should not add duplicate vertices', () {
      graph.addVertex(1);
      graph.addVertex(1);

      expect(graph.vertices.length, equals(1));
    });

    test('should add edges', () {
      graph.addEdge(1, 2, 10);
      graph.addEdge(2, 3, 20);

      expect(graph.vertices.length, equals(3));
      expect(graph.vertices[1]!.edges[graph.vertices[2]!], equals(10));
      expect(graph.vertices[2]!.edges[graph.vertices[3]!], equals(20));
    });

    test('should add bidirectional edges for undirected graph', () {
      graph.addEdge(1, 2, 10);

      expect(graph.vertices[1]!.edges[graph.vertices[2]!], equals(10));
      expect(graph.vertices[2]!.edges[graph.vertices[1]!], equals(10));
    });

    test('should add unidirectional edges for directed graph', () {
      graph = Graph(isDirected: true);
      graph.addEdge(1, 2, 10);

      expect(graph.vertices[1]!.edges[graph.vertices[2]!], equals(10));
      expect(graph.vertices[2]!.edges[graph.vertices[1]!], isNull);
    });

    test('should get all vertices', () {
      graph.addVertex(1);
      graph.addVertex(2);
      graph.addVertex(3);

      var vertices = graph.getVertices();
      expect(vertices.length, equals(3));
      expect(vertices.map((v) => v.id), containsAll([1, 2, 3]));
    });

    test('should get all edges', () {
      graph.addEdge(1, 2, 10);
      graph.addEdge(2, 3, 20);

      var edges = graph.getEdges();
      expect(edges.length, equals(4)); // 2 edges * 2 (bidirectional)
      expect(
          edges,
          containsAll([
            [1, 2, 10],
            [2, 1, 10],
            [2, 3, 20],
            [3, 2, 20],
          ]));
    });

    test('should identify bipartite graph', () {
      graph.addEdge(1, 2, 1);
      graph.addEdge(1, 4, 1);
      graph.addEdge(3, 2, 1);
      graph.addEdge(3, 4, 1);

      expect(graph.isBipartite(), isTrue);
    });

    test('should identify non-bipartite graph', () {
      graph.addEdge(1, 2, 1);
      graph.addEdge(2, 3, 1);
      graph.addEdge(3, 1, 1);

      expect(graph.isBipartite(), isFalse);
    });

    test('should throw ArgumentError for invalid vertices', () {
      graph.addVertex(1);
      expect(() => graph.addEdge(1, 2, 10), throwsArgumentError);
    });
  });
}
