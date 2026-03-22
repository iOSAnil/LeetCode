import UIKit

var greeting = "Hello, playground"

class UnionFind {
    var parent = [Int]()
    var rank = [Int]()
    init(n: Int) {
        for i in 0..<n {
            parent[i] = i
            rank[i] = 1
        }
    }
    
    func find(n1: Int) -> Int{
        var result = n1
        
        while result != parent[safe: n1] {
            if let value = parent[safe: result] {
                if parent[safe: value] != nil {
                    parent[result] = parent[parent[result]]
                }
            }
            result = parent[safe: result]!
        }
        return result
    }
    
    func union(n1: Int, n2: Int) -> Int {
        let root1 = find(n1: n1)
        let root2 = find(n1: n2)
        
        if root1 != root2 {
            if rank[safe: root1]! < rank[safe: root2]! {
                parent[root1] = root2
                return 1
            }
        }
        return 0
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        // Ensure the index is non-negative and less than the total count.
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
}
