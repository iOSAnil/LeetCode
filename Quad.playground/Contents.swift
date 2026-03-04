// Definition for a QuadTree node.
public class Node {
    public var val: Bool
    public var isLeaf: Bool
    public var topLeft: Node?
    public var topRight: Node?
    public var bottomLeft: Node?
    public var bottomRight: Node?
    public init(_ val: Bool, _ isLeaf: Bool) {
        self.val = val
        self.isLeaf = isLeaf
        self.topLeft = nil
        self.topRight = nil
        self.bottomLeft = nil
        self.bottomRight = nil
    }
}

class Solution {
    func construct(_ grid: [[Int]]) -> Node? {
        func dfs(_ g: [[Int]]) -> Node? {
            if g.count == 1 {
                return Node(g[0][0]==1, true)
            } else if isCompleteGridSingleValue(g) {
                return Node(g[0][0]==1, true)
            } else {
                let n = g.count / 2
                let node = Node(g[0][0]==1, false)
                node.topLeft = dfs(g.topLeft())
                node.topRight = dfs(g.topRight())
                node.bottomLeft = dfs(g.bottomLeft())
                node.bottomRight = dfs(g.bottomRight())
                return node
            }
        }
        
        func isCompleteGridSingleValue(_ grid: [[Int]]) -> Bool {
            let value = grid[0][0]
            var isCompleteGridSingleValue = true
            for g in grid {
                if g.allSatisfy({ $0 == value }) {
                    continue
                } else {
                    isCompleteGridSingleValue = false
                    break
                }
            }
            return isCompleteGridSingleValue
        }
        
        return dfs(grid)
        
    }
}

extension Array where Element == [Int] {
    var n: Int {
        return count/2
    }
    
    func topLeft() -> [[Int]] {
        var result = [[Int]]()
        
        for i in 0..<n {
            var row = [Int]()
            for j in 0..<n {
                row.append(self[i][j])
            }
            result.append(row)
        }
        
        return result
    }
    
    func topRight() -> [[Int]] {
        var result = [[Int]]()
        
        for i in 0..<n {
            var row = [Int]()
            for j in n..<self.count {
                row.append(self[i][j])
            }
            result.append(row)
        }
        
        return result
    }
    
    func bottomRight() -> [[Int]] {
        var result = [[Int]]()
        
        for i in n..<self.count {
            var row = [Int]()
            for j in n..<self.count {
                row.append(self[i][j])
            }
            result.append(row)
        }
        
        return result
    }
    func bottomLeft() -> [[Int]] {
        var result = [[Int]]()
        
        for i in n..<self.count {
            var row = [Int]()
            for j in 0..<n {
                row.append(self[i][j])
            }
            result.append(row)
        }
        
        return result
    }
}

