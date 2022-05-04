import UIKit

// Need to specify the type of edge
enum EdgeType {
    case directed
    case undirected
}

// Vertex will contain the value and an index
struct Vertex<T> {
    let data: T
    let index: Int
}

// We need to make them hashable and equatable to store them in a Hash Table aka Dictionary
extension Vertex: Hashable where T: Hashable {}
extension Vertex: Equatable where T: Equatable {}

extension Vertex: CustomStringConvertible {
    var description: String {
        return "\(index): \(data)"
    }
}

// An edge should have a source and a destination but the weight is optional
struct Edge<T> {
    let source: Vertex<T>
    let destination: Vertex<T>
    let weight: Double?
}

// We define a Graph generic protocol to specify the functions to create, insert and get
protocol Graph {
    associatedtype Element
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?)
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
}

// These functions are common for every Graph, default implementation added
extension Graph {
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    func add(_ edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
}

// The adjancency list contains the vertices as a hash table with a list of edges (the network)
class AdjacencyList<T: Hashable>: Graph {
    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]

    init() { }

    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(data: data, index: adjacencies.count)
        // New vertex with no edges yet
        adjacencies[vertex] = []
        return vertex
    }

    func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        // New edge for the source vertex
        adjacencies[source]?.append(edge)
    }

    func edges(from source: Vertex<T>) -> [Edge<T>] {
        // Get the edges for a specific vextex
        adjacencies[source] ?? []
    }

    func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        // Filters the first element where the destination equals to the one we are searching for and returns its weight
        edges(from: source).first { $0.destination == destination }?.weight
    }
}

extension AdjacencyList: CustomStringConvertible {
    // Just to depict the ajacencies
    var description: String {
        var result = ""
        for (vertex, edges) in adjacencies {
            var edgeString = ""
            for (i, edge) in edges.enumerated() {
                if i != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ]\n")
        }
        return result
    }
}

let graph = AdjacencyList<String>()

let paris = graph.createVertex(data: "Paris")
let tokyo = graph.createVertex(data: "Tokyo")
let mex = graph.createVertex(data: "Mexico City")
let tij = graph.createVertex(data: "Tijuana")
let sf = graph.createVertex(data: "San Francisco")
let dc = graph.createVertex(data: "Washington DC")
let la = graph.createVertex(data: "Los Angeles")
let sd = graph.createVertex(data: "San Diego")

graph.add(.undirected, from: paris, to: mex, weight: 300)
graph.add(.undirected, from: paris, to: tokyo, weight: 500)
graph.add(.undirected, from: mex, to: tokyo, weight: 350)
graph.add(.undirected, from: tokyo, to: dc, weight: 400)
graph.add(.undirected, from: la, to: sd, weight: 100)
graph.add(.undirected, from: la, to: paris, weight: 450)
graph.add(.undirected, from: sf, to: paris, weight: 400)
graph.add(.undirected, from: sf, to: tij, weight: 250)
graph.add(.undirected, from: tij, to: mex, weight: 250)

print(graph)
