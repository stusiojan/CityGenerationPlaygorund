//
//  Simulation.swift
//  Road-gen-alg
//
//  Created by Jan Stusio on 24/03/2025.
//

import Foundation

struct SimulationNodeMetadata {
    let terrainNode: TerrainNode
    let zone: Zone
    let density: Double // 0...1
    let slopeFactor: Double // 0...1
}

struct SimulationNode: GraphNode {
    let id: UUID
    var metadata: SimulationNodeMetadata
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SimulationNode, rhs: SimulationNode) -> Bool {
        lhs.id == rhs.id
    }
}

struct SimulationEdge: GraphEdge {
    let id: UUID
    let source: SimulationNode
    let destination: SimulationNode
    var metadata: Never // No metadata for simulation edges
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SimulationEdge, rhs: SimulationEdge) -> Bool {
        lhs.id == rhs.id
    }
}

typealias SimulationGraph = Graph<SimulationNode, SimulationEdge>
