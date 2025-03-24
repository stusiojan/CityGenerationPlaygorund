//
//  Graph.swift
//  Road-gen-alg
//
//  Created by Jan Stusio on 24/03/2025.
//

import Foundation

// MARK: - Base Graph Protocols

/// Protocol defining requirements for graph nodes
protocol GraphNode: Hashable {
    associatedtype NodeMetadata
    var metadata: NodeMetadata { get set }
}

/// Protocol defining requirements for graph edges
protocol GraphEdge: Hashable {
    associatedtype EdgeMetadata
    associatedtype NodeType: GraphNode
    
    var source: NodeType { get }
    var destination: NodeType { get }
    var metadata: EdgeMetadata { get set }
}

/// Protocol defining the graph structure
protocol GraphProtocol {
    associatedtype NodeType: GraphNode
    associatedtype EdgeType: GraphEdge where EdgeType.NodeType == NodeType
    
    var nodes: Set<NodeType> { get set }
    var edges: Set<EdgeType> { get set }
    
    mutating func addNode(_ node: NodeType)
    mutating func addEdge(_ edge: EdgeType)
    func getNeighbors(for node: NodeType) -> [NodeType]
}

// MARK: - Generic Graph Implementation

class Graph<N: GraphNode, E: GraphEdge>: GraphProtocol where E.NodeType == N {
    var nodes: Set<N>
    var edges: Set<E>
    
    init() {
        nodes = Set<N>()
        edges = Set<E>()
    }
    
    func addNode(_ node: N) {
        nodes.insert(node)
    }
    
    func addEdge(_ edge: E) {
        edges.insert(edge)
    }
    
    func getNeighbors(for node: N) -> [N] {
        edges.filter { $0.source == node }.map { $0.destination }
    }
}
