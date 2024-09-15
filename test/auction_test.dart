import 'package:test/test.dart';
import 'package:dart_match_master/src/models/graph.dart';
import 'package:dart_match_master/src/assignment/auction.dart';

void main() {
  group('Auction', () {
    late Graph graph;

    setUp(() {
      graph = Graph();
    });

    test('initialization', () {
      graph.addEdge(1, 'A', 10);
      graph.addEdge(2, 'B', 20);
      var auction = Auction(graph);
      expect(auction.graph, equals(graph));
      expect(auction.epsilon, equals(0.01));
    });

    test('solve simple bipartite graph', () {
      graph.addEdge(1, 'A', 10);
      graph.addEdge(1, 'B', 12);
      graph.addEdge(2, 'A', 7);
      graph.addEdge(2, 'B', 8);

      var auction = Auction(graph);
      var result = auction.solve();

      expect(result.length, equals(2));
      expect(
          result,
          containsAll([
            [1, 'B'],
            [2, 'A']
          ]));
    });

    test('solve larger bipartite graph', () {
      graph.addEdge(1, 'A', 10);
      graph.addEdge(1, 'B', 12);
      graph.addEdge(1, 'C', 8);
      graph.addEdge(2, 'A', 7);
      graph.addEdge(2, 'B', 8);
      graph.addEdge(2, 'C', 9);
      graph.addEdge(3, 'A', 11);
      graph.addEdge(3, 'B', 9);
      graph.addEdge(3, 'C', 10);

      var auction = Auction(graph);
      var result = auction.solve();

      expect(result.length, equals(3));
      expect(
          result,
          containsAll([
            [1, 'B'],
            [2, 'C'],
            [3, 'A']
          ]));
    });

    test('solve with custom epsilon', () {
      graph.addEdge(1, 'A', 10);
      graph.addEdge(1, 'B', 12);
      graph.addEdge(2, 'A', 7);
      graph.addEdge(2, 'B', 8);

      var auction = Auction(graph, epsilon: 0.1);
      var result = auction.solve();

      expect(result.length, equals(2));
      expect(
          result,
          containsAll([
            [1, 'B'],
            [2, 'A']
          ]));
    });

    test('throw error for non-bipartite graph', () {
      graph.addEdge(1, 2, 10);
      graph.addEdge(2, 3, 20);
      graph.addEdge(3, 1, 30);

      expect(() => Auction(graph), throwsA(isA<ArgumentError>()));
    });

    test('handle empty graph', () {
      var auction = Auction(graph);
      var result = auction.solve();

      expect(result, isEmpty);
    });

    test('handle graph with isolated vertices', () {
      graph.addVertex(1);
      graph.addVertex(2);
      graph.addVertex('A');
      graph.addVertex('B');
      graph.addEdge(1, 'A', 10);

      var auction = Auction(graph);
      var result = auction.solve();

      expect(result.length, equals(1));
      expect(
          result,
          containsAll([
            [1, 'A']
          ]));
    });
  });
}
