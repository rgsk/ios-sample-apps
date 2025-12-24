//
//  TodoAppView.swift
//  Music Player
//
//  Created by apple on 16/12/25.
//

/*
 TODO APP – FEATURE SUMMARY
 -------------------------
 • SwiftUI-based Todo application
 • Add new todos using a large text input + plus button
 • Todos stored as a model with id, title, and completion state
 • Mark todos as done / undone using a radio-style indicator on the left
 • Completed todos show strikethrough and faded text
 • Delete todos using a red cross button on the right
 • Drag and drop to reorder todos
 • Includes custom hex color support via Color(hex:)
 */

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}

struct Todo: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
}

struct TodoAppView: View {
    @State private var todoText = ""
    @State private var todos: [Todo] = [
        Todo(title: "Buy groceries"),
        Todo(title: "Read a book")
    ]
    
    func addTodo() {
        let trimmed = todoText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        todos.append(Todo(title: trimmed))
        todoText = ""
    }
    
    func moveTodo(from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 24)
            Text("Todo App")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 12) {
                TextField("Add a todo", text: $todoText)
                    .font(.system(size: 22))          // ⬅️ BIG text
                    .padding(.vertical, 14)            // ⬅️ BIG height
                    .padding(.horizontal, 18)
                    .background(Color(hex: "#1e1e1e"))
                    .cornerRadius(14)

                Button(action: {
                    addTodo()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 36))       // ⬅️ BIG plus
                }
            }.padding()

            List {
                ForEach($todos) { $todo in
                    HStack {
                        Button(action: {
                            todo.isDone.toggle()
                        }) {
                            Image(systemName: todo.isDone ? "largecircle.fill.circle" : "circle")
                                .font(.system(size: 22))
                                .foregroundColor(todo.isDone ? Color(hex: "#F89000") : .secondary)
                        }
                        .buttonStyle(.plain)
                        
                        Text(todo.title)
                            .font(.system(size: 20))
                            .strikethrough(todo.isDone)
                            .foregroundColor(todo.isDone ? .secondary : .primary)
                        
                        Spacer()
                        
                        Button(action: {
                            if let index = todos.firstIndex(of: todo) {
                                todos.remove(at: index)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(
                        Color(hex: "#1e1e1e")
                    )
                }
                .onMove(perform: moveTodo)
            }
        }
      
    }
}

#Preview {
    TodoAppView()
}
