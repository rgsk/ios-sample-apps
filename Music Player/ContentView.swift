import SwiftUI

struct ContentView: View {
    
    var body: some View {
                NavigationStack {
                    List {
                        NavigationLink("Dictionary", destination: DictionaryView())
                        NavigationLink("Exercise Counter", destination: ExerciseCounter())
                        NavigationLink("Todo App", destination: TodoAppView())
                        NavigationLink("Tic Tac Toe", destination: TicTacToeView())
                    }
                    .padding(.top, 8)
                    .navigationTitle("My Apps")
                }
        
       
    }
}

#Preview {
    ContentView()
}
