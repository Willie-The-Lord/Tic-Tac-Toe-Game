//
//  Grid.swift
//  Tic Tac Toe
//
//  Created by Sung-Jie Hung on 2023/1/30.
//

import Foundation

class Grid {
    var squares = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    var winner = [Int]()
    
    // Check whether the winner occurs
    func check() {
        for combination in winningCombinations {
            if squares[combination[0]] != 0 && squares[combination[0]] == squares[combination[1]] && squares[combination[1]] == squares[combination[2]] {
                if squares[combination[0]] == 1 {
                    // X
                    winner = [1, combination[0], combination[2]]
                } else {
                    // O
                    winner = [2, combination[0], combination[2]]
                }
            }
        }
        
        // Check whether ties
        let tie = squares.allSatisfy { $0 > 0 }
        if tie && winner.isEmpty {
            winner = [3]
        }
    }
    
    func clearGrid(){
        squares = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        winner = [Int]()
    }
}
