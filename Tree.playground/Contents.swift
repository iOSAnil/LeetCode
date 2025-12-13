import UIKit

public class Node {
    public var val: Int
    public var children: [Node]
    public init(_ val: Int) {
        self.val = val
        self.children = []
    }
}

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

//------------------------------------------------------------Tree Traversals---------------------------------------------------------------
/*
 InOrder - Left, Root, Right
 PreOrder - Root, Left, Right
 PostOrder - Left, Right, Root
 */

//https://leetcode.com/problems/binary-tree-inorder-traversal/
func inorderWithRecursion(_ root: TreeNode?) -> [Int] {
    var array = [Int]()
    func inOrdering(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        inOrdering(root.left)
        array.append(root.val)
        inOrdering(root.right)
    }
    inOrdering(root)
    return array
}

func preorderWithoutRecursion(_ root: Node?) -> [Int] {
    var stack = [Node]()
    var result = [Int]()
    guard let root = root else {
        return result
    }
    stack.append(root)
    
    while !stack.isEmpty {
        let node = stack.removeFirst()
        result.append(node.val)
        stack.insert(contentsOf: node.children, at: 0)
    }
    
    return result
}

//https://leetcode.com/problems/n-ary-tree-preorder-traversal
func preorderWithRecursion(_ root: Node?) -> [Int] {
    var array = [Int]()
    func preOrdering(_ root: Node?, _ list: [Int]) {
        guard let root = root else {
            return
        }
        array.append(root.val)
        for node in root.children {
            preOrdering(node, array)
        }
    }
    preOrdering(root, array)
    return array
}

//https://leetcode.com/problems/n-ary-tree-postorder-traversal
func postorderWithRecursion(_ root: Node?) -> [Int] {
    var array = [Int]()
    func postOrdering(_ root: Node?, _ list: [Int]) {
        guard let root = root else {
            return
        }
        for node in root.children {
            postOrdering(node, array)
        }
        array.append(root.val)
    }
    postOrdering(root, array)
    return array
}

let rootNode = Node(1)
let nodeThree = Node(3)
nodeThree.children = [Node(5), Node(6)]
rootNode.children = [nodeThree, Node(2), Node(4)]


/*
            1
        3      2   4
    5      6
*/

print(preorderWithRecursion(rootNode)) // [1, 3, 5, 6, 2, 4]
print(preorderWithoutRecursion(rootNode)) // [1, 3, 5, 6, 2, 4]
print(postorderWithRecursion(rootNode))

let treeNode = TreeNode(1, nil, TreeNode(2, TreeNode(3), nil))

/*
      1
        2
      3
*/
print(inorderWithRecursion(treeNode))

//------------------------------------------------------------Tree Traversals---------------------------------------------------------------

// ----------------------------------------------909. Snakes and Ladders------------------------------------------------------------------------------
//https://leetcode.com/problems/snakes-and-ladders/
class SnakesAndLadders {
    func snakesAndLadders(_ board: [[Int]]) -> Int {
        var board = board
        board.reverse()
        let boardLength = board.count
        
 
        var visited: Set<Int> = Set()
        
        var queue = [(1, 0)]
        visited.insert(1)
 
        while !queue.isEmpty {
            let poppedElement = queue.removeFirst()
            let (square, moves) = poppedElement
            for i in 1...6 {
                var newSquare = square+i
                let (r,c) = (newSquare).toPosition(in: boardLength)
                newSquare = board[r][c] != -1 ? board[r][c] : newSquare
                if newSquare == boardLength*boardLength {
                    return moves+1
                }
                if !visited.contains(newSquare) {
                    queue.append((newSquare, moves+1))
                    visited.insert(newSquare)
                }
            }
        }
        return -1
    }
}

extension Int {
    func toPosition(in rowLength: Int) -> (Int, Int) {
        let row = (self - 1)/rowLength
        var column = (self - 1)%rowLength
        if !row.isMultiple(of: 2) {
            column = rowLength - 1 - column
        }
        return (row, column)
    }
}

print(SnakesAndLadders().snakesAndLadders([[-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1],[-1,-1,-1,-1,-1,-1],[-1,35,-1,-1,13,-1],[-1,-1,-1,-1,-1,-1],[-1,15,-1,-1,-1,-1]]))
// -----------------------------------------------------------------------------------------------------------------------------------------

 

//-----------------------------------------Construct Binary Tree from Preorder and Inorder Traversal------------------------------------
/*
 Given two integer arrays preorder and inorder where preorder is the preorder traversal of a binary tree and inorder is the inorder traversal of the same tree, construct and return the binary tree.
 Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
 Output: [3,9,20,null,null,15,7]
 */
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    if preorder.isEmpty || inorder.isEmpty {
        return nil
    }
    let root = TreeNode(preorder[0])
    if let mid = inorder.firstIndex(of: preorder[0]) {
        root.left = buildTree(Array(preorder[1..<mid+1]), Array(inorder[0..<mid]))
        root.right = buildTree(Array(preorder[mid+1..<preorder.count]), Array(inorder[mid + 1..<inorder.count]))
    }
    return root
}
//------------------------------------------------------------------------------------------------------------------------------------------

