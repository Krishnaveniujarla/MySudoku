//
//  main.swift
//  Interview
//
//  Created by Admin on 11/10/2560 BE.
//  Copyright © 2560 BE Admin. All rights reserved.
//

let example: Sudoku = [
    [5, 3, 0,  0, 7, 0,  0, 0, 0],
    [6, 0, 0,  1, 9, 5,  0, 0, 0],
    [0, 9, 8,  0, 0, 0,  0, 6, 0],
    
    [8, 0, 0,  0, 6, 0,  0, 0, 3],
    [4, 0, 0,  8, 0, 3,  0, 0, 1],
    [7, 0, 0,  0, 2, 0,  0, 0, 6],
    
    [0, 6, 0,  0, 0, 0,  2, 8, 0],
    [0, 0, 0,  4, 1, 9,  0, 0, 5],
    [0, 0, 0,  0, 8, 0,  0, 7, 0],
]

print("\nPuzzle:")
printSudoku(example)
if let solutionForExample = solveSudoku(example) {
    print("\nSolution:")
    printSudoku(solutionForExample)
}
else {
    print("No solution")
}


// Find all solutions to this puzzle (there are 20)
let diagonals: Sudoku = [
    [9, 0, 0,  0, 0, 0,  6, 0, 0],
    [0, 8, 0,  0, 0, 0,  0, 5, 0],
    [0, 0, 7,  0, 0, 0,  0, 0, 4],
    
    [3, 0, 0,  6, 0, 0,  9, 0, 0],
    [0, 2, 0,  0, 5, 0,  0, 8, 0],
    [0, 0, 1,  0, 0, 4,  0, 0, 7],
    
    [6, 0, 0,  9, 0, 0,  3, 0, 0],
    [0, 5, 0,  0, 8, 0,  0, 2, 0],
    [0, 0, 4,  0, 0, 7,  0, 0, 1],
]

print("\nPuzzle:")
printSudoku(diagonals)
var solutionCount: Int = 0
findAllSolutions(diagonals) { solution in
    solutionCount += 1
    
    print("\nSolution \(solutionCount):")
    printSudoku(solution)
    
    // Return true to continue
    return true
}
if solutionCount == 0 {
    print("No solutions")
}
