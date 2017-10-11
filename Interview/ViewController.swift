//
//  ViewController.swift
//  Interview
//
//  Created by Admin on 10/11/2017 .
//  Copyright © 2560 BE Admin. All rights reserved.
//

import UIKit



public struct Mark {
    public let value: Int
    
    public init(_ value: Int) {
        assert(1 <= value && value <= 9, "only values 1...9 are valid for a mark")
        
        switch value {
        case 1...9: self.value = value
        default:    self.value = 1
        }
    }
}

/// A Sudoku square is empty or has a mark with value 1...9.
public enum Square: ExpressibleByIntegerLiteral {
    case Empty
    case Marked(Mark)
    
        public init(integerLiteral value: IntegerLiteralType) {
        switch value {
        case 1...9: self = .Marked(Mark(value))
        default:    self = .Empty
        }
    }
    
    var isEmpty: Bool {
        switch self {
        case .Empty:   return true
        case .Marked(_): return false
        }
    }
    
    func isMarkedWithValue(_ value: Int) -> Bool {
        switch self {
        case .Empty:            return false
        case .Marked(let mark): return mark.value == value
        }
    }
}

// A Sudoku puzzle is a 9x9 matrix of squares
public typealias Sudoku = [[Square]]

/// Find a solution for a sudoku puzzle
public func solveSudoku(_ s: Sudoku) -> Sudoku? {
    if let (row, col) = findEmptySquare(s) {
        for mark in 1...9 {
            if canTryMark(mark, atRow: row, column: col, inSudoku: s) {
                let candidate = copySudoku(s, withMark: mark, atRow: row, column: col)
                if let solution = solveSudoku(candidate) {
                    return solution
                }
            }
        }
        
        // No solution
        return nil
    }
    else {
        // No empty squares, so it's solved
        return s
    }
}

public func findAllSolutions(_ s: Sudoku, processAndContinue: @escaping (Sudoku) -> Bool) {
    // This will be set true if processAndContinue() returns false
    var stop = false
    
    var recursiveCall: (Sudoku) -> () = { _ in return }
    
    
    func findSolutionsUntilStop(_ s: Sudoku) {
        if let (row, col) = findEmptySquare(s) {
            for mark in 1...9 {
                if stop {
                    break
                }
                
                if canTryMark(mark, atRow: row, column: col, inSudoku: s) {
                    let candidate = copySudoku(s, withMark: mark, atRow: row, column: col)
                    recursiveCall(candidate)
                }
            }
        }
        else {
            // No empty squares, so this is a solution
            if !processAndContinue(s) {
                stop = true
            }
        }
    }
    
    recursiveCall = findSolutionsUntilStop
    
    findSolutionsUntilStop(s)
}

/// Print a Sudoku as a 9x9 matrix
///
/// Empty squares are printed as dots.
public func printSudoku(_ s: Sudoku) {
    for row in s {
        for square in row {
            switch (square) {
            case .Empty:            print(".", terminator: "")
            case .Marked(let mark): print(mark.value, terminator: "")
            }
        }
        print()
    }
}

/// Create a copy of a Sudoku with an additional mark
private func copySudoku(_ s: Sudoku, withMark mark: Int, atRow row: Int, column col: Int) -> Sudoku {
    var result = Sudoku(s)
    
    var newRow  = Array(s[row])
    newRow[col] = .Marked(Mark(mark))
    result[row] = newRow
    
    return result
}

private func findEmptySquare(_ s: Sudoku) -> (Int, Int)? {
    for row in 0..<9 { for col in 0..<9 {
        if s[row][col].isEmpty { return (row, col) }
        }}
    return nil
}

/// Determine whether putting the specified mark at the specified square would violate uniqueness constrains
private func canTryMark(_ mark: Int, atRow row: Int, column col: Int, inSudoku s: Sudoku) -> Bool {
    return !doesSudoku(s, containMark: mark, inRow: row)
        && !doesSudoku(s, containMark: mark, inColumn: col)
        && !doesSudoku(s, containMark: mark, in3x3BoxWithRow: row, column: col)
}

/// Determine whether a specified mark already exists in a specified row
private func doesSudoku(_ s: Sudoku, containMark mark: Int, inRow row: Int) -> Bool {
    for col in 0..<9 {
        if s[row][col].isMarkedWithValue(mark) { return true }
    }
    return false
}

/// Determine whether a specified mark already exists in a specified column
private func doesSudoku(_ s: Sudoku, containMark mark: Int, inColumn col: Int) -> Bool {
    for row in 0..<9 {
        if s[row][col].isMarkedWithValue(mark) { return true }
    }
    return false
}

/// Determine whether a specified mark already exists in a specified 3x3 subgrid
private func doesSudoku(_ s: Sudoku, containMark mark: Int, in3x3BoxWithRow row: Int, column col: Int) -> Bool {
    let boxMinRow = (row / 3) * 3
    let boxMaxRow = boxMinRow + 2
    let boxMinCol = (col / 3) * 3
    let boxMaxCol = boxMinCol + 2
    
    for row in boxMinRow...boxMaxRow {
        for col in boxMinCol...boxMaxCol {
            if s[row][col].isMarkedWithValue(mark) { return true }
        }
    }
    return false
}
