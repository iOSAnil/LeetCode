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



print(minimumTotal([[2],[3,4],[6,5,7],[4,1,8,3]]))
print(minimumTotalMinimizeSpace([[2],[3,4],[6,5,7],[4,1,8,3]]))
print(minPathSum([[1,3,1],[1,5,1],[4,2,1]]))
print(minPathSumWithLessComplexitySameLogic([[1,3,1],[1,5,1],[4,2,1]]))
print(uniquePathsWithObstacles([[0,0,0],[0,1,0],[0,0,0]]))
