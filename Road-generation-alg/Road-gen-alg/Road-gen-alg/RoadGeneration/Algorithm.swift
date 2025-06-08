////
////  Algorithm.swift
////  Road-gen-alg
////
////  Created by Jan Stusio on 08/06/2025.
////
//
///*
// "L-System is a formalism defined around string rewriting [...] string rewriting for something huge like a city would be slow."
// 
// For `Advanced L-Systems` O(N^2)
// For flatten with priority queue O() - flattening gives a performance boost, priority queue was added for clarity.
// 
// ```
// initialize priority queue Q with a single entry:
//    r(0,ra,qa)
// 
// initialize segment list S to empty
// 
// until Q is empty
//    pop smallest r(t,ra,qa) from Q
//        compute (nqa, state) = localConstraints(qa)
//        if (state == SUCCEED) {
//            add segment(ra) to S
//            addZeroToThreeRoadsUsingGlobalGoals(Q, t+1, qa,ra)
// ```
// */
//
//import Foundation
//import Collections
//
//// MARK: - Struktury danych
//
///// Stan przetwarzania lokalnych ograniczeń
//enum ProcessingState {
//    case succeed
//    case failed
//    case pending
//}
//
///// Wpis w kolejce priorytetowej
//struct QueueEntry: Comparable {
//    let t: Int      // czas/iteracja
//    let ra: String  // identyfikator drogi/segmentu
//    let qa: String  // parametry/stan
//    
//    init(_ t: Int, _ ra: String, _ qa: String) {
//        self.t = t
//        self.ra = ra
//        self.qa = qa
//    }
//    
//    // Implementacja Comparable - porównanie według czasu t
//    static func < (lhs: QueueEntry, rhs: QueueEntry) -> Bool {
//        return lhs.t < rhs.t
//    }
//    
//    static func == (lhs: QueueEntry, rhs: QueueEntry) -> Bool {
//        return lhs.t == rhs.t && lhs.ra == rhs.ra && lhs.qa == rhs.qa
//    }
//}
//
//// MARK: - Główny algorytm
//
//class RoadPlanningAlgorithm {
//    /// Kolejka priorytetowa używająca Heap z Swift Collections
//    private var queue = Heap<QueueEntry>()
//    
//    /// Lista segmentów - wynik algorytmu
//    private var segmentList: [String] = []
//    
//    /// Inicjalizuje algorytm z początkowym wpisem
//    /// - Parameters:
//    ///   - initialRa: początkowy identyfikator drogi
//    ///   - initialQa: początkowe parametry
//    func initialize(initialRa: String = "road_0", initialQa: String = "params_0") {
//        // Dodaj początkowy wpis r(0, ra, qa) do kolejki
//        let initialEntry = QueueEntry(0, initialRa, initialQa)
//        queue.insert(initialEntry)
//        
//        // Wyczyść listę segmentów
//        segmentList.removeAll()
//        
//        print("🚀 Algorytm zainicjalizowany z wpisem: r(\(initialEntry.t), \(initialEntry.ra), \(initialEntry.qa))")
//    }
//    
//    /// Główna pętla algorytmu
//    func execute() {
//        print("\n📋 Rozpoczynam wykonywanie algorytmu...")
//        var iteration = 0
//        
//        while !queue.isEmpty {
//            iteration += 1
//            print("\n--- Iteracja \(iteration) ---")
//            
//            // Pobierz najmniejszy element z kolejki (min-heap)
//            let entry = queue.removeMin()
//            print("📤 Pobieram z kolejki: r(\(entry.t), \(entry.ra), \(entry.qa))")
//            
//            // Oblicz lokalne ograniczenia
//            let (nqa, state) = localConstraints(qa: entry.qa)
//            print("🔍 Lokalne ograniczenia: nqa=\(nqa), state=\(state)")
//            
//            // Jeśli stan == SUCCEED
//            if state == .succeed {
//                // Dodaj segment do listy
//                segmentList.append(entry.ra)
//                print("✅ Dodano segment '\(entry.ra)' do listy")
//                
//                // Dodaj 0-3 drogi używając globalnych celów
//                addZeroToThreeRoadsUsingGlobalGoals(
//                    currentTime: entry.t + 1,
//                    qa: nqa,
//                    ra: entry.ra
//                )
//            } else {
//                print("❌ Segment '\(entry.ra)' odrzucony (stan: \(state))")
//            }
//        }
//        
//        print("\n🏁 Algorytm zakończony po \(iteration) iteracjach")
//        printResults()
//    }
//    
//    /// Funkcja symulująca lokalne ograniczenia
//    /// - Parameter qa: parametry wejściowe
//    /// - Returns: tupla z nowymi parametrami i stanem
//    private func localConstraints(qa: String) -> (String, ProcessingState) {
//        // Symulacja przetwarzania lokalnych ograniczeń
//        let random = Int.random(in: 0...10)
//        
//        let newQa = "processed_\(qa)_\(random)"
//        let state: ProcessingState
//        
//        // 70% szans na sukces, 30% na niepowodzenie
//        if random <= 7 {
//            state = .succeed
//        } else {
//            state = .failed
//        }
//        
//        return (newQa, state)
//    }
//    
//    /// Dodaje 0-3 nowe wpisy do kolejki na podstawie globalnych celów
//    /// - Parameters:
//    ///   - currentTime: aktualny czas/iteracja
//    ///   - qa: parametry
//    ///   - ra: identyfikator drogi
//    private func addZeroToThreeRoadsUsingGlobalGoals(currentTime: Int, qa: String, ra: String) {
//        // Losowo wybierz liczbę nowych dróg (0-3)
//        let numberOfNewRoads = Int.random(in: 0...3)
//        print("🛤️  Dodaję \(numberOfNewRoads) nowych dróg na podstawie globalnych celów")
//        
//        for i in 0..<numberOfNewRoads {
//            let newRa = "\(ra)_branch_\(i)"
//            let newQa = "\(qa)_extended_\(i)"
//            let newEntry = QueueEntry(currentTime, newRa, newQa)
//            
//            queue.insert(newEntry)
//            print("   ➕ Dodano do kolejki: r(\(newEntry.t), \(newEntry.ra), \(newEntry.qa))")
//        }
//    }
//    
//    /// Wyświetla informacje o aktualnym stanie kolejki
//    func printQueueStatus() {
//        print("\n📊 Status kolejki:")
//        print("   Liczba elementów: \(queue.count)")
//        if let min = queue.min {
//            print("   Następny element: r(\(min.t), \(min.ra), \(min.qa))")
//        }
//    }
//    
//    /// Wyświetla wyniki algorytmu
//    private func printResults() {
//        print("\n📊 WYNIKI ALGORYTMU:")
//        print("Liczba segmentów w liście S: \(segmentList.count)")
//        
//        if !segmentList.isEmpty {
//            print("Segmenty:")
//            for (index, segment) in segmentList.enumerated() {
//                print("  \(index + 1). \(segment)")
//            }
//        } else {
//            print("Lista segmentów jest pusta")
//        }
//    }
//    
//    /// Zwraca aktualną listę segmentów
//    var segments: [String] {
//        return segmentList
//    }
//    
//    /// Zwraca liczbę elementów w kolejce
//    var queueSize: Int {
//        return queue.count
//    }
//}
//
//func test() {
//    // MARK: - Rozszerzone przykłady użycia
//    
//    print("=== ALGORYTM PLANOWANIA DRÓG z Swift Collections ===")
//    
//    // Przykład 1: Podstawowe użycie
//    print("\n🔄 PRZYKŁAD 1: Podstawowe wykonanie")
//    let algorithm1 = RoadPlanningAlgorithm()
//    algorithm1.initialize(initialRa: "main_road", initialQa: "initial_params")
//    algorithm1.execute()
//    
//    print("\n🎯 Finalne segmenty: \(algorithm1.segments)")
//    
//    // Przykład 2: Krok po kroku z monitorowaniem kolejki
//    print("\n\n🔄 PRZYKŁAD 2: Wykonanie krok po kroku")
//    let algorithm2 = RoadPlanningAlgorithm()
//    algorithm2.initialize(initialRa: "highway_A1", initialQa: "params_v2")
//    
//    // Wykonaj kilka kroków ręcznie dla demonstracji
//    var stepCounter = 0
//    while algorithm2.queueSize > 0 && stepCounter < 3 {
//        stepCounter += 1
//        print("\n=== KROK \(stepCounter) ===")
//        algorithm2.printQueueStatus()
//        
//        // Tutaj można by wykonać pojedynczy krok algorytmu
//        // W pełnej implementacji można by wydzielić logikę pojedynczego kroku
//    }
//    
//    // Dokończ resztę
//    print("\n🔚 Dokańczam pozostałe kroki...")
//    algorithm2.execute()
//    
//    // MARK: - Demonstracja zaawansowanych funkcji Heap
//    
//    print("\n\n=== DEMONSTRACJA HEAP z Swift Collections ===")
//    
//    // Tworzenie heap i podstawowe operacje
//    var demonstrationHeap = Heap<QueueEntry>()
//    
//    // Dodawanie elementów w różnej kolejności
//    let entries = [
//        QueueEntry(5, "road_E", "params_E"),
//        QueueEntry(1, "road_A", "params_A"),
//        QueueEntry(3, "road_C", "params_C"),
//        QueueEntry(2, "road_B", "params_B"),
//        QueueEntry(4, "road_D", "params_D")
//    ]
//    
//    print("➕ Dodaję elementy do heap w kolejności: 5,1,3,2,4")
//    for entry in entries {
//        demonstrationHeap.insert(entry)
//        print("   Dodano: r(\(entry.t), \(entry.ra), \(entry.qa))")
//    }
//    
//    print("\n📤 Pobieranie elementów w kolejności priorytetowej:")
//    while !demonstrationHeap.isEmpty {
//        let entry = demonstrationHeap.removeMin()
//        print("   Pobrano: r(\(entry.t), \(entry.ra), \(entry.qa))")
//    }
//    
//    print("\n✨ Heap automatycznie sortuje elementy według priorytetu!")
//
//}
