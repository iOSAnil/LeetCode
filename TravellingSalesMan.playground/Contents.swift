//Definition for a binary tree node.
import Foundation

// ------------------------------------------------------------------------------------------------------------------------------
func shortestPathLength(_ graph: [[Int]]) -> Int {
    let n = graph.count
    if n <= 1 { return 0 }
    
    // Target mask: all nodes visited (e.g., for 4 nodes, 1111 in binary = 15)
    let endingMask = (1 << n) - 1
    
    // Queue for BFS: (currentNode, currentMask)
    var queue = [(Int, Int)]()
    
    // visited[node][mask] to avoid redundant processing of the same state
    var visited = Array(repeating: Array(repeating: false, count: 1 << n), count: n)
    
    // We can start at ANY node
    for i in 0..<n {
        queue.append((i, 1 << i))
        visited[i][1 << i] = true
    }
    
    var steps = 0
    
    while !queue.isEmpty {
        let size = queue.count
        
        for _ in 0..<size {
            let (curr, mask) = queue.removeFirst()
            
            // If this state has all nodes visited, return steps
            if mask == endingMask {
                return steps
            }
            
            // Explore neighbors
            for neighbor in graph[curr] {
                let nextMask = mask | (1 << neighbor)
                
                if !visited[neighbor][nextMask] {
                    visited[neighbor][nextMask] = true
                    queue.append((neighbor, nextMask))
                }
            }
        }
        steps += 1
    }
    
    return -1
}
print(shortestPathLength([[1],[0,2,4],[1,3,4],[2],[1,2]]))
