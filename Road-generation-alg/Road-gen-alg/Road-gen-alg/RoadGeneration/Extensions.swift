////
////  Extensions.swift
////  Road-gen-alg
////
////  Created by Jan Stusio on 10/01/2025.
////
//
//import Foundation
//
//extension Point: Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(x)
//        hasher.combine(y)
//    }
//     
//    static func == (lhs: Point, rhs: Point) -> Bool {
//        return lhs.x == rhs.x && lhs.y == rhs.y
//    }
//}
//
//
///// Rozszerzenie RoadGenerator o metodę dostępu do segmentów
//extension RoadGenerator {
//    func getSegments() -> [Point] {
//        return segments
//    }
//}
//
//extension RoadGenerator {
//    private func generateRandomPoint(near point: Point, maxDistance: Double = 1.0) -> Point {
//        let angle = Double.random(in: 0...(2 * .pi))
//        let distance = Double.random(in: 0.1...maxDistance)
//         
//        let newX = min(max(point.x + cos(angle) * distance, 0), 1)
//        let newY = min(max(point.y + sin(angle) * distance, 0), 1)
//         
//        return Point(x: newX, y: newY)
//    }
//     
//    private func localConstraints(qa: [Point]) -> ([Point], ConstraintState) {
//        // Prosta implementacja sprawdzająca, czy punkt nie jest zbyt blisko istniejących punktów
//        let lastPoint = qa.last!
//        for segment in segments {
//            let dx = lastPoint.x - segment.x
//            let dy = lastPoint.y - segment.y
//            let distance = sqrt(dx * dx + dy * dy)
//             
//            if distance < 0.5 { // Minimalna dozwolona odległość
//                return (qa, .fail)
//            }
//        }
//        return (qa, .succeed)
//    }
//     
//    func addZeroToThreeRoadsUsingGlobalGoals(time: Int, qa: [Point], ra: [Point]) {
//        let numRoads = Int.random(in: 0...3)
//         
//        for _ in 0..<numRoads {
//            guard let lastPoint = qa.last else { continue }
//            let newPoint = generateRandomPoint(near: lastPoint)
////            print("New point: \(newPoint)")
//             
//            var newRa = ra
//            newRa.append(newPoint)
//             
//            var newQa = qa
//            newQa.append(newPoint)
//             
//            let newRoad = Road(time: time, roadArray: newRa, queueArray: newQa)
//            if roadCount < maxRoadCount {
//                priorityQueue.enqueue(newRoad)
//                print("New road added. Road: \(newRoad)")
//                roadCount += 1
//            } else {
//                print("Max road count reached")
//            }
//        }
//    }
//}
