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

print(preorderWithRecursion(rootNode))
print(postorderWithRecursion(rootNode))

let treeNode = TreeNode(1, nil, TreeNode(2, TreeNode(3), nil))

/*
      1
        2
      3
*/
print(inorderWithRecursion(treeNode))

//------------------------------------------------------------Tree Traversals---------------------------------------------------------------
