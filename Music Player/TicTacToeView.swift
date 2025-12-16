//
//  TicTacToeView.swift
//  Music Player
//
//  Created by apple on 16/12/25.
//


import SwiftUI

struct TicTacToeView: View {

    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    @State private var board: [String?] = Array(repeating: nil, count: 9)
    @State private var currentPlayer = "X"
    @State private var winner: String? = nil
    @State private var isDraw = false

    func checkWinner() {
        let winningPatterns = [
            [0,1,2], [3,4,5], [6,7,8], // rows
            [0,3,6], [1,4,7], [2,5,8], // columns
            [0,4,8], [2,4,6]           // diagonals
        ]

        for pattern in winningPatterns {
            if let first = board[pattern[0]],
               first == board[pattern[1]],
               first == board[pattern[2]] {
                winner = first
                return
            }
        }

        if !board.contains(where: { $0 == nil }) {
            isDraw = true
        }
    }

    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .padding()

            if let winner = winner {
                Text("\(winner) Wins 🎉")
                    .font(.title2)
                    .foregroundColor(.purple)
            } else if isDraw {
                Text("It's a Draw 🤝")
                    .font(.title2)
                    .foregroundColor(.orange)
            } else {
                Text("Turn: \(currentPlayer)")
                    .font(.title2)
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<9) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.blue.opacity(0.2))
                            .cornerRadius(10)
                            .aspectRatio(1, contentMode: .fit)

                        if let value = board[index] {
                            Text(value)
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(value == "X" ? .red : .green)
                        }
                    }
                    .onTapGesture {
                        if board[index] == nil && winner == nil && !isDraw {
                            board[index] = currentPlayer
                            checkWinner()
                            if winner == nil {
                                currentPlayer = currentPlayer == "X" ? "O" : "X"
                            }
                        }
                    }
                }
            }
            .padding()
            Button("Reset Game") {
                board = Array(repeating: nil, count: 9)
                currentPlayer = "X"
                winner = nil
                isDraw = false
            }
            .padding()
            .font(.title3)
        }
    }
}

#Preview {
    TicTacToeView()
}
