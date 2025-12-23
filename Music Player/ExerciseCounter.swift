import SwiftUI
import AVFoundation

struct ExerciseCounter: View {
    
    // Default values
    private let defaultCount: Int = 20
    private let defaultIntervalSeconds: Int = 1
    private let defaultRestSeconds: Int = 5
    private let defaultTotalLoops: Int = 1
    
    let sounds = Array(0...20)
    @State private var player: AVAudioPlayer?
    @State private var count: Int
    @State private var currentIndex: Int = 1
    @State private var isPlayingSequence: Bool = false
    @State private var intervalSeconds: Int
    @State private var restSeconds: Int
    @State private var totalLoops: Int
    @State private var currentLoop: Int = 1
    @State private var isPaused: Bool = false
    
    init() {
        _count = State(initialValue: defaultCount)
        _intervalSeconds = State(initialValue: defaultIntervalSeconds)
        _restSeconds = State(initialValue: defaultRestSeconds)
        _totalLoops = State(initialValue: defaultTotalLoops)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 20)
                
                VStack(spacing: 16) {
                    Stepper(value: $count, in: 1...20) {
                        Text("Count: \(count)")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    
                    Stepper(value: $intervalSeconds, in: 1...10, step: 1) {
                        Text("Duration: \(intervalSeconds) sec")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    
                    Stepper(value: $restSeconds, in: 0...20) {
                        Text("Rest: \(Int(restSeconds)) sec")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    
                    Stepper(value: $totalLoops, in: 1...20) {
                        Text("Loops: \(totalLoops)")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .onChange(of: count) {
                    resetCounting()
                }
                .onChange(of: intervalSeconds) {
                    resetCounting()
                }
                .onChange(of: restSeconds) {
                    resetCounting()
                }
                .onChange(of: totalLoops) {
                    resetCounting()
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    Button {
                        startCounting()
                    } label: {
                        Label(
                            isPlayingSequence ? "Playing" : "Start",
                            systemImage: "play.fill"
                        )
                        .frame(maxWidth: .infinity, minHeight: 40)
                    }
                    .disabled(isPlayingSequence)
                    .buttonStyle(.bordered)
                    .tint(.green)
                    
                    Button {
                        togglePause()
                    } label: {
                        Label(
                            isPaused ? "Resume" : "Pause",
                            systemImage: isPaused ? "playpause.fill" : "pause.fill"
                        )
                        .frame(maxWidth: .infinity, minHeight: 40)
                    }
                    .disabled(!isPlayingSequence)
                    .buttonStyle(.bordered)
                    .tint(.orange)
                    
                    Button {
                        resetCounting()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity, minHeight: 40)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding()
                
            }
            .navigationTitle("Exercise Counter")
        }
    }
    
    func startCounting() {
        guard count >= 1 else { return }
        currentIndex = 1
        currentLoop = 1
        isPlayingSequence = true
        isPaused = false
        playNext()
    }
    
    func playNext() {
        guard isPlayingSequence else { return }
        
        if isPaused {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                playNext()
            }
            return
        }
        
        if currentIndex > count {
            if currentLoop < totalLoops {
                currentLoop += 1
                currentIndex = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(restSeconds)) {
                    playNext()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(restSeconds)) {
                    isPlayingSequence = false
                }
            }
            return
        }
        
        playSound(number: currentIndex)
        currentIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(intervalSeconds)) {
            playNext()
        }
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func resetCounting() {
        isPlayingSequence = false
        isPaused = false
        currentIndex = 1
        currentLoop = 1
        player?.stop()
    }
    
    func playSound(number: Int) {
        let fileMap: [Int: String] = [
            0: "67738__timkahn__0",
            1: "67739__timkahn__1",
            2: "67750__timkahn__2",
            3: "67752__timkahn__3",
            4: "67753__timkahn__4",
            5: "67754__timkahn__5",
            6: "67755__timkahn__6",
            7: "67756__timkahn__7",
            8: "67757__timkahn__8",
            9: "67758__timkahn__9",
            10: "67740__timkahn__10",
            11: "67741__timkahn__11",
            12: "67742__timkahn__12",
            13: "67743__timkahn__13",
            14: "67744__timkahn__14",
            15: "67745__timkahn__15",
            16: "67746__timkahn__16",
            17: "67747__timkahn__17",
            18: "67748__timkahn__18",
            19: "67749__timkahn__19",
            20: "67751__timkahn__20"
        ]
        
        guard let fileName = fileMap[number],
              let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else {
            print("Sound file not found for \(number)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound \(number)")
        }
    }
}


#Preview {
    ExerciseCounter()
}
