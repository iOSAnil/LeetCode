
public class Node {
    public var val: Int
    public var left: Node?
    public var right: Node?
    public var next: Node?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
        self.next = nil
    }
}

//---------------------------------------------117. Populating Next Right Pointers in Each Node II----------------------------------------------

func connect(_ root: Node?) -> Node? {
    guard let root = root else {
        return nil
    }
    var queue = [root]
    var level = [Node: Int]()
    var currentLevel = 0
    level[root] = currentLevel
    while !queue.isEmpty {
        let node = queue.removeFirst()
        
        if let nextNode = queue.first {
            if level[nextNode] == level[node] {
                node.next = nextNode
            } else {
                node.next = nil
            }
        } else {
            node.next = nil
        }
        
        if let left = node.left {
            queue.append(left)
            level[left] = level[node]! + 1
        }
        
        if let right = node.right {
            queue.append(right)
            level[right] = level[node]! + 1
        }
    }
    return root
}

//----------------
// Figure out each level size by
// levelSize = queue.count - procesedNodesTillNowFromQueue
// Add child nodes of one levels in the queue in one go.
// keep track of first node in the level by prev variable and set to current node as next node.
func connectOptimizeSpace(_ root: Node?) -> Node? {
    guard let root = root else {
        return nil
    }
    var queue = [root]
    var front = 0
    while front < queue.count {
        let levelSize = queue.count - front
        var prev: Node?
        
        for _ in 0..<levelSize {
            let node = queue[front]
            front += 1
            
            prev?.next = node
            prev = node
            
            if let left = node.left {
                queue.append(left)
            }
            
            if let right = node.right {
                queue.append(right)
            }
        }
        
        prev?.next = nil
    }
    return root
}

extension Node: Hashable {
   public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs === rhs
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

//------------------------------------------------------------------------------------------------------------------------------------------

func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var graph = (0..<numCourses).reduce(into: [Int: [Int]](), { $0[$1] = [] })
    for preq in prerequisites {
        graph[preq[0]]?.append(preq[1])
    }
    var visitedNode = Set<Int>()
    var visitingNode = Set<Int>()

    func dfs(_ node: Int) -> Bool {
        if visitingNode.contains(node) {    // cycle
            return false
        }
        
        if visitedNode.contains(node) {    // Already processed
            return true
        }
        
        visitingNode.insert(node)

        for prerequisite in graph[node]! {
            if !dfs(prerequisite) {   // if any preRequisite is circular return false
                return false
            }
        }
        visitingNode.remove(node)
        visitedNode.insert(node)

        return true
    }
    
    for i in 0..<numCourses {
        if !dfs(i) {
            return false
        }
    }
    
    return true
}

print(canFinish(5, [[0,1], [0,2], [1,3], [1,4], [3,4]]))



func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
    var graph = (0..<numCourses).reduce(into: [Int: [Int]](), { $0[$1] = [] })
    for preq in prerequisites {
        graph[preq[0]]?.append(preq[1])
    }
    var visitedNode = Set<Int>()
    var visitingNode = Set<Int>()
    var result = [Int]()
    
    func dfs(_ node: Int) -> Bool {
        if visitingNode.contains(node) {    // cycle
            return false
        }
        
        if visitedNode.contains(node) {    // Already All preRequisites are done in other dependancy
            return true
        }
        
        visitingNode.insert(node)

        for prerequisite in graph[node]! {
            if !dfs(prerequisite) {   // if any preRequisite is circular return false
                return false
            }
        }
        visitingNode.remove(node)
        visitedNode.insert(node)
        result.append(node)

        return true
    }
    
    for i in 0..<numCourses {
        if !dfs(i) {
            return []
        }
    }
    
    return result
}


