//
//  RoadNetworkView.swift
//  Road-gen-alg
//
//  Created by Jan Stusio on 10/01/2025.
//

import SwiftUI

struct RoadNetworkView: View {
    @State private var segments: [Point] = []
    @State private var generator: RoadGenerator
    
    private let canvasSize: CGFloat = 600
    private let lineWidth: CGFloat = 2
    private let pointRadius: CGFloat = 4
    
    init() {
        _generator = State(initialValue: RoadGenerator())
    }
    
    var body: some View {
        VStack {
            Canvas { context, size in
                for i in stride(from: 0, to: segments.count - 1, by: 1) {
                    let start = segments[i]
                    let end = segments[i + 1]
                    
                    let startPoint = CGPoint(
                        x: start.x * size.width,
                        y: start.y * size.height
                    )
                    let endPoint = CGPoint(
                        x: end.x * size.width,
                        y: end.y * size.height
                    )
                    
                    let path = Path { p in
                        p.move(to: startPoint)
                        p.addLine(to: endPoint)
                    }
                     
                    context.stroke(
                        path,
                        with: .color(.blue),
                        lineWidth: lineWidth
                    )
                    
                    let startCircle = Path { p in
                        p.addEllipse(in: CGRect(
                            x: startPoint.x - pointRadius,
                            y: startPoint.y - pointRadius,
                            width: pointRadius * 2,
                            height: pointRadius * 2
                        ))
                    }
                     
                    let endCircle = Path { p in
                        p.addEllipse(in: CGRect(
                            x: endPoint.x - pointRadius,
                            y: endPoint.y - pointRadius,
                            width: pointRadius * 2,
                            height: pointRadius * 2
                        ))
                    }
                     
                    context.fill(startCircle, with: .color(.red))
                    context.fill(endCircle, with: .color(.blue))
                }
            }
            .frame(width: canvasSize, height: canvasSize)
            .border(Color.gray, width: 1)
             
            Button("Generate new road network") {
                generateNewRoadNetwork()
            }
            .padding()
        }
    }
     
    private func generateNewRoadNetwork() {
        let startPoint = Point(x: 0.5, y: 0.5)
        
//        generator = RoadGenerator()
        segments.removeAll()
        
        generator.generateRoads(startingPoint: startPoint)
        
        segments = generator.getSegments()
        print("Segments: \(segments)")
    }
}

#Preview {
    RoadNetworkView()
}
