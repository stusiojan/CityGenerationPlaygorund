//
//  RoadGenerator.swift
//  Road-gen-alg
//
//  Created by Jan Stusio on 10/01/2025.
//

import Foundation

//TODO: Dodać obsługę błędów i przypadków brzegowych
class RoadGenerator {
    var priorityQueue: PriorityQueue<Road>
    var segments: [Point] = []
    
    var maxRoadCount: Int = 100
    var roadCount: Int = 0
     
    init() {
        // Inicjalizacja kolejki priorytetowej z funkcją porównującą czas
        self.priorityQueue = PriorityQueue<Road> { $0.time < $1.time }
        print("Road Generator initialized")
    }
     
    /// Funkcja sprawdzająca lokalne ograniczenia
    private func localConstraints(qa: [Point]) -> ([Point], ConstraintState) {
        // Tutaj implementacja sprawdzania lokalnych ograniczeń
        // Zwraca zmodyfikowaną tablicę punktów i stan
        // Przykładowa implementacja
        print("Checking local constraints")
        return (qa, .succeed)
    }
     
    /// Funkcja dodająca nowe drogi na podstawie globalnych celów
//    private func addZeroToThreeRoadsUsingGlobalGoals(time: Int, qa: [Point], ra: [Point]) {
//        // Tutaj implementacja dodawania 0-3 nowych dróg
//        // Przykładowa implementacja
//         
//        // Przykład dodania jednej nowej drogi
//        let newRoad = Road(time: time, roadArray: ra, queueArray: qa)
//        if roadCount < maxRoadCount {
//            priorityQueue.enqueue(newRoad)
//            print("New road added. Road: \(newRoad)")
//            roadCount += 1
//        } else {
//            print("Max road count reached")
//        }
//        
//    }
     
    // Główna funkcja generująca drogi
    func generateRoads(startingPoint: Point) {
        // Inicjalizacja pierwszej drogi
        let initialRoad = Road(time: 0,
                             roadArray: [startingPoint],
                             queueArray: [startingPoint])
        priorityQueue.enqueue(initialRoad)
         
        // Główna pętla algorytmu
        while !priorityQueue.isEmpty {
            guard let currentRoad = priorityQueue.dequeue() else { continue }
             
            let (newQa, state) = localConstraints(qa: currentRoad.queueArray)
             
            if state == .succeed {
                // Dodaj segment do listy segmentów
                segments.append(contentsOf: currentRoad.roadArray)
                 
                // Dodaj nowe drogi do kolejki
                addZeroToThreeRoadsUsingGlobalGoals(
                    time: currentRoad.time + 1,
                    qa: newQa,
                    ra: currentRoad.roadArray
                )
            }
        }
    }
}
