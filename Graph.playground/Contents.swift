import UIKit

//Definition for a Node.
public class Node {
    public var val: Int
    public var neighbors: [Node?]
    public init(_ val: Int) {
        self.val = val
        self.neighbors = []
    }
}
extension Node: Hashable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.val == rhs.val
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(val)
    }
}
//------------------------------------------------------------------------------------------------------------------------
// 
func cloneGraph(_ node: Node?) -> Node? {
    guard let node = node else { return nil }
    
    var dict = [Node: Node]()
    
    func clone(_ node: Node) -> Node {
        
        if let existing = dict[node] {
            return existing
        }
        
        let copy = Node(node.val)
        dict[node] = copy  // Assign copy to dict first and then put the neighbours clone
        
        for neighbour in node.neighbors {
            if let n = neighbour {
                copy.neighbors.append(clone(n))
            }
        }
        
        return copy
    }
    
    return clone(node)
}
//------------------------------------------------------------------------------------------------------------------------

