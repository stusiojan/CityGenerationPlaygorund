//
//  Terrain.swift
//  Road-gen-alg
//
//  Created by Jan Stusio on 24/03/2025.
//

import Foundation

struct TerrainNodeMetadata {
    let x: Double
    let y: Double
    let z: Double
    let surface: Surface
}

/// Edge weight
/// - Parameters:
///     - slope: Height difference between two nodes
struct TerrainEdgeMetadata {
    let slope: Double
}

struct TerrainNode: GraphNode {
    let id: UUID
    var metadata: TerrainNodeMetadata
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TerrainNode, rhs: TerrainNode) -> Bool {
        lhs.id == rhs.id
    }
}

struct TerrainEdge: GraphEdge {
    let id: UUID
    let source: TerrainNode
    let destination: TerrainNode
    var metadata: TerrainEdgeMetadata
    
    init(id: UUID, source: TerrainNode, destination: TerrainNode) {
        self.id = id
        self.source = source
        self.destination = destination
        self.metadata = {
            let diff = source.metadata.z - destination.metadata.z
            return TerrainEdgeMetadata(slope: abs(diff))
        }()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TerrainEdge, rhs: TerrainEdge) -> Bool {
        lhs.id == rhs.id
    }
}

typealias TerrainGraph = Graph<TerrainNode, TerrainEdge>
