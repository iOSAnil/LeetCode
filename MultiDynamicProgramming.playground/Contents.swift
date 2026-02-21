//-----------------------------------120. Triangle----------------------------------------------------------------------
//https://leetcode.com/problems/triangle
func minimumTotal(_ triangle: [[Int]]) -> Int {
    let size = triangle.count
    var dp = Array(repeating: Array(repeating: 0, count: size+1), count: size+1)
    
    for i in stride(from: size-1, through: 0, by: -1) {
        for j in stride(from: 0, through: triangle[i].count-1, by: 1) {
            dp[i][j] = min(dp[i+1][j], dp[i+1][j+1]) + triangle[i][j]
        }
    }
    return dp[0][0]
}

func minimumTotalMinimizeSpace(_ triangle: [[Int]]) -> Int {
    let size = triangle.count
    var dp = Array(repeating: 0, count: size+1)
    
    for i in stride(from: size-1, through: 0, by: -1) {
        for j in stride(from: 0, through: triangle[i].count-1, by: 1) {
            dp[j] = min(dp[j], dp[j+1]) + triangle[i][j]
        }
    }
    return dp[0]
}
//-----------------------------------64. Minimum Path Sum----------------------------------------------------------------------
// https://leetcode.com/problems/minimum-path-sum/
func minPathSum(_ grid: [[Int]]) -> Int {
    let rows = grid.count
    let columns = grid[0].count
    var dp = Array(repeating: Array(repeating: -1, count: columns+1), count: rows+1)
    
    for i in stride(from: rows-1, through: 0, by: -1) {
        for j in stride(from: columns-1, through: 0, by: -1) {
            if dp[i+1][j] != -1 && dp[i][j+1] != -1 {
                dp[i][j] = min(dp[i+1][j], dp[i][j+1]) + grid[i][j]
            } else if dp[i+1][j] == -1 && dp[i][j+1] == -1 {
                dp[i][j] = grid[i][j]
            } else if dp[i+1][j] == -1 {
                dp[i][j] = dp[i][j+1] + grid[i][j]
            } else if dp[i][j+1] == -1 {
                dp[i][j] = dp[i+1][j] + grid[i][j]
            }
        }
    }
    return dp[0][0]
}

func minPathSumWithLessComplexitySameLogic(_ grid: [[Int]]) -> Int {
    let rows = grid.count
    let cols = grid[0].count
    
    var dp = Array(repeating: Array(repeating: 0, count: cols), count: rows)
    
    for i in stride(from: rows - 1, through: 0, by: -1) {
        for j in stride(from: cols - 1, through: 0, by: -1) {
            
            if i == rows - 1 && j == cols - 1 {
                dp[i][j] = grid[i][j]
            }
            else if i == rows - 1 { // last row → can only go right
                dp[i][j] = grid[i][j] + dp[i][j + 1]
            }
            else if j == cols - 1 { // last column → can only go down
                dp[i][j] = grid[i][j] + dp[i + 1][j]
            }
            else {
                dp[i][j] = grid[i][j] + min(dp[i + 1][j], dp[i][j + 1])
            }
        }
    }
    
    return dp[0][0]
}
// ---------------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------63. Unique Paths II------------------------------------------------------------------------
//https://leetcode.com/problems/unique-paths-ii
func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
    let rows = obstacleGrid.count
    let cols = obstacleGrid[0].count
    
    var dp = Array(repeating: 0, count: cols)
    
    dp[0] = obstacleGrid[0][0] == 1 ? 0 : 1
    
    for i in 0..<rows {
        for j in 0..<cols {
            
            if obstacleGrid[i][j] == 1 {
                dp[j] = 0
            } else if j > 0 {
                dp[j] += dp[j - 1]
            }
        }
    }
    
    return dp[cols - 1]
}

func uniquePathsWithObstaclesDFS(_ obstacleGrid: [[Int]]) -> Int {
    let rows = obstacleGrid.count
    let columns = obstacleGrid[0].count
    
    var memo = Array(repeating: Array(repeating: -1, count: columns), count: rows)
    
    func dfs(_ row: Int, _ column: Int) -> Int {
        if row >= rows || column >= columns || obstacleGrid[row][column] == 1 {
            return 0
        }
        if row == rows-1 && column == columns-1 {
            return 1
        }
        
        if memo[row][column] != -1 {
            return memo[row][column]
        }
        
        let right = dfs(row, column+1)
        let down = dfs(row+1, column)
        
        memo[row][column] = right + down
        return memo[row][column]
    }
    return dfs(0, 0)
}

//Best to easy understand
func uniquePathsWithObstaclesDP(_ obstacleGrid: [[Int]]) -> Int {
    let rows = obstacleGrid.count
    let cols = obstacleGrid[0].count
    
    var grid = obstacleGrid
    
    if grid[0][0] == 1 { return 0 }
    grid[0][0] = 1
    
    for i in 0..<rows {
        for j in 0..<cols {
            if i == 0 && j == 0 { continue }
            
            if grid[i][j] == 1 {
                grid[i][j] = 0
            } else {
                if j > 0 { grid[i][j] += grid[i][j - 1] }
                if i > 0 { grid[i][j] += grid[i - 1][j] }
            }
        }
    }
    return grid[rows - 1][cols - 1]
}
//---------------------------------------------------------------------------------------------------------------------------------------


//------------------------------------------5. Longest Palindromic Substring-------------------------------------------------------------
// Expand from center and check all the palindromes
// Handle it for both even and odd length of Strings.
func longestPalindrome(_ s: String) -> String {
    var maxLength = 0
    var startIndex = 0
    var chars = Array(s)
    
    for i in 0..<s.count {
        // odd string handling
        expandAroundCenter(chars, i, i, &startIndex, &maxLength)
        
        // even string handling
        expandAroundCenter(chars, i, i+1, &startIndex, &maxLength)
    }
    
    return String(chars[startIndex..<(startIndex + maxLength)])
}

func expandAroundCenter(_ chars: [Character],
                        _ left: Int,
                        _ right: Int,
                        _ startIndex: inout Int,
                        _ maxLength: inout Int) {
    var left = left
    var right = right
    
    while left >= 0 && right < chars.count && chars[left] == chars[right] {
        if right - left + 1 > maxLength {
            startIndex = left
            maxLength = right - left + 1
        }
        left -= 1
        right += 1
    }
}
//---------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------97. Interleaving String---------------------------------------------------------------
// Bottom up DP
// https://leetcode.com/problems/interleaving-string/
func isInterleave(_ s1: String, _ s2: String, _ s3: String) -> Bool {
    if s1.count + s2.count != s3.count {
        return false
    }
    let s1Char = Array(s1)
    let s2Char = Array(s2)
    let s3Char = Array(s3)
    
    var dp = Array(repeating: Array(repeating: false, count: s2.count + 1), count: s1.count + 1)
    dp[s1.count][s2.count] = true // if reaches this index then both string are consumed to make s3
    
    for i in stride(from: s1.count, through: 0, by: -1) {
        for j in stride(from: s2.count, through: 0, by: -1) {
            if i < s1.count && s1Char[i] == s3Char[i + j] && dp[i+1][j] {    // s1 i index should make s3 i + j  and dp [i+1][j] which is next index of first string and same j index of s2 should also make the string s3
                dp[i][j] = true
            }
            if j < s2.count && s2Char[j] == s3Char[i + j]  && dp[i][j+1] {
                dp[i][j] = true
            }
        }
    }
    return dp[0][0]
}
//---------------------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------221. Maximal Square------------------------------------------------------------------
// Use bottom up approach and calculate dp[i][j] = min(right, bottom, diagonal) + 1 square are that it can generate.
func maximalSquare(_ matrix: [[Character]]) -> Int {
    var dp = Array(repeating: Array(repeating: 0, count: matrix[0].count), count: matrix.count)
    var maxValue = 0
    
    for i in stride(from: dp.count-1, through: 0, by: -1) {
        for j in stride(from: dp[0].count-1, through: 0, by: -1) {
            if i == dp.count-1 || j == dp[0].count-1 {
                dp[i][j] = Int(String(matrix[i][j])) ?? 0
            } else if Int(String(matrix[i][j])) == 1 {
                dp[i][j] = min(dp[i+1][j], dp[i][j+1], dp[i+1][j+1]) + 1
            }
            maxValue = max(dp[i][j], maxValue)
        }
    }
    return maxValue*maxValue
}
//---------------------------------------------------------------------------------------------------------------------------------------

print(minimumTotal([[2],[3,4],[6,5,7],[4,1,8,3]]))
print(minimumTotalMinimizeSpace([[2],[3,4],[6,5,7],[4,1,8,3]]))
print(minPathSum([[1,3,1],[1,5,1],[4,2,1]]))
print(minPathSumWithLessComplexitySameLogic([[1,3,1],[1,5,1],[4,2,1]]))
print(uniquePathsWithObstacles([[0,0,0],[0,1,0],[0,0,0]]))
print(isInterleave("abc","defg","adefgbc"))
print(maximalSquare([["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]])) //4
