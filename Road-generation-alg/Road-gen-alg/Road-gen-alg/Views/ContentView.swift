//
//  ContentView.swift
//  Road-gen-alg
//
//  Created by Jan Stusio on 10/01/2025.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
////            RoadNetworkView()
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI
import Collections

// MARK: - Struktury danych z algorytmu

enum ProcessingState {
    case succeed
    case failed
    case pending
}

/// t - czas/iteracja
/// ra - identyfikator drogi/segmentu
/// qa - parametry/stan
struct QueueEntry: Comparable {
    let t: Int
    let ra: String
    let qa: String
    
    init(_ t: Int, _ ra: String, _ qa: String) {
        self.t = t
        self.ra = ra
        self.qa = qa
    }
    
    static func < (lhs: QueueEntry, rhs: QueueEntry) -> Bool {
        return lhs.t < rhs.t
    }
    
    static func == (lhs: QueueEntry, rhs: QueueEntry) -> Bool {
        return lhs.t == rhs.t && lhs.ra == rhs.ra && lhs.qa == rhs.qa
    }
}

// MARK: - Struktury dla wizualizacji

struct Road {
    let id: String
    let startPoint: CGPoint
    let endPoint: CGPoint
    let generation: Int // Generacja drogi (dla kolorowania)
    let parentId: String?
    
    var midPoint: CGPoint {
        CGPoint(
            x: (startPoint.x + endPoint.x) / 2,
            y: (startPoint.y + endPoint.y) / 2
        )
    }
}

struct RoadNode {
    let id: String
    let position: CGPoint
    let generation: Int
    var connections: [String] = []
}

// MARK: - Algorytm z wizualizacją

class VisualRoadPlanningAlgorithm: ObservableObject {
    @Published var roads: [Road] = []
    @Published var nodes: [String: RoadNode] = [:]
    @Published var isGenerating = false
    @Published var currentIteration = 0
    @Published var totalSegments = 0
    
    private var queue = Heap<QueueEntry>()
    private var segmentList: [String] = []
    private let canvasSize: CGSize
    
    init(canvasSize: CGSize = CGSize(width: 400, height: 400)) {
        self.canvasSize = canvasSize
    }
    
    func generateRoadmap() {
        Task {
            await MainActor.run {
                isGenerating = true
                currentIteration = 0
                totalSegments = 0
                
                // Reset danych
                roads.removeAll()
                nodes.removeAll()
                segmentList.removeAll()
                queue = Heap<QueueEntry>()
                
                // Inicjalizuj z centralnym punktem
                let centerPoint = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
                let rootNode = RoadNode(id: "root", position: centerPoint, generation: 0)
                nodes["root"] = rootNode
                
                // Dodaj początkowy wpis do kolejki
                let initialEntry = QueueEntry(0, "root", "initial_params")
                queue.insert(initialEntry)
            }
            
            // Wykonaj algorytm z animacją
            await executeWithAnimation()
            
            await MainActor.run {
                isGenerating = false
            }
        }
    }
    
    private func executeWithAnimation() async {
        while !queue.isEmpty && roads.count < 50 { // Limit dla czytelności
            let entry = queue.removeMin()
            let (nqa, state) = localConstraints(qa: entry.qa)
            
            if state == .succeed {
                await createRoadSegment(from: entry, with: nqa)
                
                await MainActor.run {
                    currentIteration += 1
                    segmentList.append(entry.ra)
                    totalSegments += 1
                }
                
                addRoadsUsingGlobalGoals(
                    currentTime: entry.t + 1,
                    qa: nqa,
                    ra: entry.ra
                )
                
                // Animacja - pauza między krokami
                try? await Task.sleep(nanoseconds: 200_000_000) // 200ms
            }
        }
    }
    
    @MainActor
    private func createRoadSegment(from entry: QueueEntry, with qa: String) async {
        guard let parentNode = nodes[entry.ra] else { return }
        
        // Generuj losowe kierunki dla nowych połączeń
        let numberOfConnections = Int.random(in: 1...3)
        let generation = parentNode.generation + 1
        
        for i in 0..<numberOfConnections {
            let angle = Double.random(in: 0...(2 * Double.pi))
            let distance = Double.random(in: 30...80)
            
            let newX = parentNode.position.x + CGFloat(cos(angle) * distance)
            let newY = parentNode.position.y + CGFloat(sin(angle) * distance)
            
            // Sprawdź granice canvas
            let clampedX = max(20, min(canvasSize.width - 20, newX))
            let clampedY = max(20, min(canvasSize.height - 20, newY))
            let newPosition = CGPoint(x: clampedX, y: clampedY)
            
            let newNodeId = "\(entry.ra)_\(i)"
            let newNode = RoadNode(
                id: newNodeId,
                position: newPosition,
                generation: generation
            )
            
            // Dodaj węzeł i drogę
            nodes[newNodeId] = newNode
            
            let road = Road(
                id: "road_\(entry.ra)_to_\(newNodeId)",
                startPoint: parentNode.position,
                endPoint: newPosition,
                generation: generation,
                parentId: entry.ra
            )
            
            roads.append(road)
            
            // Zaktualizuj połączenia
            nodes[entry.ra]?.connections.append(newNodeId)
        }
    }
    
    /// Przykładowe ograniczenia lokalne:
    /// Sprawdzanie kolizji z istniejącymi drogami
    /// Weryfikacja maksymalnej długości segmentu
    /// Kontrola gęstości sieci w danym obszarze
    /// Sprawdzanie terenu (przeszkody, ograniczenia)
    /// Kryteria jakości (krzywe vs proste drogi)
    private func localConstraints(qa: String) -> (String, ProcessingState) {
        let random = Int.random(in: 0...10)
        let newQa = "processed_\(qa)_\(random)"
        let state: ProcessingState = random <= 8 ? .succeed : .failed // 80% success rate
        return (newQa, state)
    }
    
    /// Przykładowe cele globalne:
    /// Kierowanie rozwoju w stronę określonych celów
    /// Tworzenie połączeń między odległymi obszarami
    /// Budowanie sieci z określoną topologią
    /// Optymalizacja pod kątem przepustowości/odległości
    private func addRoadsUsingGlobalGoals(currentTime: Int, qa: String, ra: String) {
        let numberOfNewRoads = Int.random(in: 0...2) // Zmniejszone dla lepszej wizualizacji
        
        for i in 0..<numberOfNewRoads {
            let newRa = "\(ra)_\(i)"
            let newQa = "\(qa)_extended_\(i)"
            let newEntry = QueueEntry(currentTime, newRa, newQa)
            queue.insert(newEntry)
        }
    }
}

// MARK: - SwiftUI Views

struct RoadmapVisualizationView: View {
    @StateObject private var algorithm = VisualRoadPlanningAlgorithm()
    @State private var showStats = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack {
                Text("🛤️ Road Network Generator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Road generation alogithm visualization")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Stats Panel
            if showStats {
                StatsPanel(algorithm: algorithm)
                    .transition(.opacity)
            }
            
            // Main Canvas
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                
                // Road Network
                RoadNetworkCanvas(roads: algorithm.roads, nodes: algorithm.nodes)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // Loading overlay
                if algorithm.isGenerating {
                    GeneratingOverlay(iteration: algorithm.currentIteration)
                }
                
                // Empty state
                if algorithm.roads.isEmpty && !algorithm.isGenerating {
                    EmptyStateView()
                }
            }
            .frame(height: 400)
            .animation(.easeInOut(duration: 0.3), value: algorithm.roads.count)

            
            // Controls
            HStack(spacing: 15) {
                Button(action: {
                    algorithm.generateRoadmap()
                }) {
                    HStack {
                        Image(systemName: algorithm.isGenerating ? "arrow.clockwise" : "map")
                        Text(algorithm.isGenerating ? "Generating..." : "Generate random roadmap and render")
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .background(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .disabled(algorithm.isGenerating)
                .scaleEffect(algorithm.isGenerating ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: algorithm.isGenerating)
                
                Button(action: {
                    withAnimation(.spring()) {
                        showStats.toggle()
                    }
                }) {
                    Image(systemName: showStats ? "chart.bar.fill" : "chart.bar")
                        .foregroundColor(.primary)
                        .padding(12)
                }
                .buttonStyle(.plain)
                .background(
                    LinearGradient(
                        colors: [.cyan, .cyan.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
            }
            
            Spacer()
        }
        .padding()
    }
}

struct RoadNetworkCanvas: View {
    let roads: [Road]
    let nodes: [String: RoadNode]
    
    var body: some View {
        Canvas { context, size in
            // Draw roads
            for road in roads {
                let path = Path { path in
                    path.move(to: road.startPoint)
                    path.addLine(to: road.endPoint)
                }
                
                // Road color based on generation
                let roadColor = colorForGeneration(road.generation)
                
                context.stroke(
                    path,
                    with: .color(roadColor),
                    style: StrokeStyle(
                        lineWidth: max(1, 4 - CGFloat(road.generation)),
                        lineCap: .round
                    )
                )
            }
            
            // Draw nodes
            for node in nodes.values {
                let nodeColor = colorForGeneration(node.generation)
                let radius: CGFloat = node.generation == 0 ? 8 : max(3, 6 - CGFloat(node.generation))
                
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: node.position.x - radius,
                        y: node.position.y - radius,
                        width: radius * 2,
                        height: radius * 2
                    )),
                    with: .color(nodeColor)
                )
                
                // White border for root node
                if node.generation == 0 {
                    context.stroke(
                        Path(ellipseIn: CGRect(
                            x: node.position.x - radius,
                            y: node.position.y - radius,
                            width: radius * 2,
                            height: radius * 2
                        )),
                        with: .color(.white),
                        lineWidth: 2
                    )
                }
            }
        }
    }
    
    private func colorForGeneration(_ generation: Int) -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
        return colors[min(generation, colors.count - 1)]
    }
}

struct StatsPanel: View {
    @ObservedObject var algorithm: VisualRoadPlanningAlgorithm
    
    var body: some View {
        HStack(spacing: 30) {
            StatItem(title: "Iteracje", value: "\(algorithm.currentIteration)")
            StatItem(title: "Segmenty", value: "\(algorithm.totalSegments)")
            StatItem(title: "Drogi", value: "\(algorithm.roads.count)")
            StatItem(title: "Węzły", value: "\(algorithm.nodes.count)")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct GeneratingOverlay: View {
    let iteration: Int
    
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.blue)
            
            Text("Generowanie...")
                .font(.headline)
                .padding(.top, 8)
            
            Text("Iteracja \(iteration)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(Color.white.opacity(0.95))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "map.circle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No road network")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Press \"Generate random roadmap and render\" button to start")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

// MARK: - App Entry Point

struct ContentView: View {
    var body: some View {
#if os(macOS)
        RoadmapVisualizationView()
#else
        NavigationView {
            RoadmapVisualizationView()
                .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
#endif
    }
}

#Preview {
    ContentView()
}
