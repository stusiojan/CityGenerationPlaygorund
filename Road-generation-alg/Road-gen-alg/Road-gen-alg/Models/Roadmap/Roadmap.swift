//
//  Roadmap.swift
//  Road-gen-alg
//
//  Created by Jan Stusio on 24/03/2025.
//

import Foundation

struct RoadNodeMetadata {
    let intersectionType: IntersectionType
}

struct RoadEdgeMetadata {
    let laneNum: Int
}
//
//struct RoadNode: GraphNode {
//    let id: UUID
//    var metadata: RoadNodeMetadata
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: RoadNode, rhs: RoadNode) -> Bool {
//        lhs.id == rhs.id
//    }
//}
//
//struct RoadEdge: GraphEdge {
//    let id: UUID
//    let source: RoadNode
//    let destination: RoadNode
//    var metadata: RoadEdgeMetadata
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: RoadEdge, rhs: RoadEdge) -> Bool {
//        lhs.id == rhs.id
//    }
//}
//
//typealias RoadmapGraph = Graph<RoadNode, RoadEdge>
