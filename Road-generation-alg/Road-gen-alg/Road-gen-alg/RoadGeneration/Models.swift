////
////  Models.swift
////  Road-gen-alg
////
////  Created by Jan Stusio on 10/01/2025.
////
//
//import Foundation
//
//struct Point {
//    let x: Double
//    let y: Double
//}
//
//struct Road {
//    let time: Int
//    let roadArray: [Point]
//    let queueArray: [Point]
//}
//
//struct PriorityQueue<T> {
//    private var elements: [T] // Można zoptymalizować wydajność używając kopca binarnego zamiast sortowanej tablicy
//    private let priorityFunction: (T, T) -> Bool
//     
//    init(priorityFunction: @escaping (T, T) -> Bool) {
//        self.elements = []
//        self.priorityFunction = priorityFunction
//    }
//     
//    mutating func enqueue(_ element: T) {
//        elements.append(element)
//        elements.sort(by: priorityFunction)
//    }
//     
//    mutating func dequeue() -> T? {
//        return elements.isEmpty ? nil : elements.removeFirst()
//    }
//     
//    var isEmpty: Bool {
//        return elements.isEmpty
//    }
//}
//
///// Enum dla stanu sprawdzenia lokalnych ograniczeń
//enum ConstraintState {
//    case succeed
//    case fail
//}
