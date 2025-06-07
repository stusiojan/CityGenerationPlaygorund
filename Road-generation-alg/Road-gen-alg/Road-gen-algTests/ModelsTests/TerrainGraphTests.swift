//
//  TerrainGraphTests.swift
//  Road-gen-algTests
//
//  Created by Jan Stusio on 24/03/2025.
//

import Testing
import Foundation
@testable import Road_gen_alg

@Suite("GraphTests")
struct TerrainGraphTests {
    
    let terrainGraph = TerrainGraph()

    @Test func addNode() async throws {
        let tnMeta: TerrainNodeMetadata = .init(
            x: 0,
            y: 0,
            z: 0,
            surface: .solidGround
        )
        let terrainNode: TerrainNode = .init(
            id: UUID(),
            metadata: tnMeta
        )
        terrainGraph.addNode(terrainNode)
        #expect(terrainGraph.nodes.count == 1)
    }
    
    @Test func addEdge() async throws {
        let sourceTnMeta: TerrainNodeMetadata = .init(
            x: 0,
            y: 0,
            z: 1,
            surface: .solidGround
        )
        
        let destTnMeta: TerrainNodeMetadata = .init(
            x: 0,
            y: 0,
            z: 0,
            surface: .solidGround
        )
        let sourceNode: TerrainNode = .init(
            id: UUID(),
            metadata: sourceTnMeta
        )
        let destNode: TerrainNode = .init(
            id: UUID(),
            metadata: destTnMeta
        )
        
        let terrainEdge: TerrainEdge = .init(
            id: UUID(),
            source: sourceNode,
            destination: destNode
        )
        terrainGraph.addEdge(terrainEdge)
        #expect(terrainGraph.edges.count == 1)
        #expect(terrainGraph.edges.first?.metadata.slope == 1.0)
    }
    

}
