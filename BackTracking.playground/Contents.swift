import UIKit

//--------------------------------------------------------------------------------------------------------------------------------------

func letterCombinations(_ n: Int) -> [String] {
    var res = [String]()
    
    func dfs(startIndex: Int, path: [String]) {
        var path = path
        if startIndex == n {
            res.append(path.joined())
            return
        }
        for letter in "ab" {
            path.append(String(letter))
            dfs(startIndex: startIndex + 1, path: path)
            path.removeLast()
        }
    }
    dfs(startIndex: 0, path: [])
    return res
}

print(letterCombinations(2))
//--------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------51. N-Queens------------------------------------------------------------------------
// https://leetcode.com/problems/n-queens/description/ (Hard)
func solveNQueens(_ n: Int) -> [[String]] {
    func isLeftDiagonalSafe(_ board: [[String]], _ row: Int, _ col: Int, _ n: Int) -> Bool {
        var isSafe = true
        var row = row - 1
        var col = col - 1
        while row >= 0 && col >= 0 {
            if board[row][col] == "Q" {
                isSafe = false
                break
            }
            row -= 1
            col -= 1
        }
        return isSafe
    }
    func isRightDiagonalSafe(_ board: [[String]], _ row: Int, _ col: Int, _ n: Int) -> Bool {
        var isSafe = true
        var row = row - 1
        var col = col + 1
        while row >= 0 && col < n {
            if board[row][col] == "Q" {
                isSafe = false
                break
            }
            row -= 1
            col += 1
        }
        return isSafe
    }
    func isColumnSafe(_ board: [[String]], _ row: Int, _ col: Int) -> Bool {
        var columnArray: [String] = []
        for i in 0..<row {
            columnArray.append(board[i][col])
        }
        return columnArray.allSatisfy({$0 != "Q"})
    }
    func isSafe(_ board: [[String]], _ row: Int, _ col: Int, _ n: Int) -> Bool {
        let isColumnSafe = isColumnSafe(board, row ,col)
        let isLeftDiagonalSafe = isLeftDiagonalSafe(board, row, col, n)
        let isRightDiagonalSafe = isRightDiagonalSafe(board, row, col, n)
        return isColumnSafe && isLeftDiagonalSafe && isRightDiagonalSafe
    }
    
    func queens(_ board: inout [[String]], _ row: Int, _ n: Int) {
        if row == n {
            var tempArray = [String]()
            for i in 0..<board.count {
                var tempBoard = ""
                for j in 0..<board[i].count {
                    tempBoard += board[i][j]
                }
                tempArray.append(tempBoard)
            }
            answer.append(tempArray)
        }
        
        for j in 0..<n {
            if isSafe(board, row, j, n) {
                board[row][j] = "Q"
                queens(&board, row+1, n)
                board[row][j] = "."
            }
        }
        
    }
    
    var board = Array(repeating: Array(repeating: ".", count: n), count: n)
    var answer = [[String]]()
    queens(&board, 0, n)
    return answer
}

print(solveNQueens(4))

//------------------------------------------------17. Letter Combinations of a Phone Number---------------------------------------------------
//https://leetcode.com/problems/letter-combinations-of-a-phone-number/description/
func letterCombinations(_ digits: String) -> [String] {
    if digits.isEmpty {
        return []
    }
    var result = [String]()
    let charArray = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]
    let array = digits.compactMap({charArray[Int(String($0))!]})
    
    func backTrack(_ index: Int, _ paths: inout String) {
        if index == digits.count {
            result.append(paths)
            return
        }
        
        for char in array[index] {
            paths.append(char)
            backTrack(index+1, &paths)
            paths.removeLast()
        }
    }
    var paths = ""
    backTrack(0, &paths)
    return result
}

print(letterCombinations("23"))

//--------------------------------------------------------------------------------------------------------------------------------------


//------------------------------------------------784. Letter Case Permutation---------------------------------------------------
//https://leetcode.com/problems/letter-case-permutation/description/
func letterCasePermutation(_ s: String) -> [String] {
    var result: [String] = []
    
    func backtrack(_ currentState: inout [String], _ index: Int) {
        if index == s.count {
            result.append(currentState.joined())
            return
        }
        
        let option = String(s[s.index(s.startIndex, offsetBy: index)])
        if Int(option) == nil {
            currentState.append(option.lowercased())
            backtrack(&currentState, index + 1)
            currentState.removeLast()
            
            currentState.append(option.uppercased())
            backtrack(&currentState, index + 1)
            currentState.removeLast()
        } else {
            currentState.append(option)
            backtrack(&currentState, index + 1)
            currentState.removeLast()
        }
    }
    
    var currentState: [String] = []
    backtrack(&currentState, 0)
    
    return result
}
//--------------------------------46. Permutations------------------------------------------------------------
// https://leetcode.com/problems/permutations
func permute(_ nums: [Int]) -> [[Int]] {
    var result = [[Int]]()
    var currentPath = [Int]()
    
    func backtrack(remainingChoices: [Int]) {
        // 1. Base Case: Goal Reached (e.g., path is correct length)
        if currentPath.count == nums.count {
            result.append(currentPath) // Store a COPY of the path
            return
        }
        
        
        for i in 0..<remainingChoices.count {
            let choice = remainingChoices[i]
            
            // 3. Validation/Constraint Check
            if currentPath.contains(choice) || currentPath.count == nums.count {
                continue
            }
            
            // 4. Make the choice
            currentPath.append(choice)
            
            // 5. Recursion (move to next state)
            backtrack(remainingChoices: remainingChoices)
            
            // 6. Backtrack (Undo the choice)
            if !currentPath.isEmpty {
                currentPath.removeLast()
            }
        }
        
    }
    backtrack(remainingChoices: nums)
    return result
}


print(permute([5,4,6,2]))
