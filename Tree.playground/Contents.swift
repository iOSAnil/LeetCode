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

//------------------------Construct Binary Tree from Inorder and Postorder Traversal--------------------------------------------------------
/*
 Input: inorder = [9,3,15,20,7], postorder = [9,15,7,20,3]
Output: [3,9,20,null,null,15,7]
*/
func buildTree1(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
    if inorder.isEmpty || postorder.isEmpty {
        return nil
    }
    let rootVal = postorder.last!
    var node = TreeNode(rootVal)
    
    guard let index = inorder.firstIndex(of: rootVal) else {
        return nil
    }
    let leftInorder = Array(inorder[0..<index])
    let rightInorder = Array(inorder[index+1..<inorder.count])
    node.left = buildTree(leftInorder, Array(postorder[0..<leftInorder.count]))
    node.right = buildTree(rightInorder, Array(postorder[leftInorder.count..<postorder.count-1]))
    return node
}
//------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------114. Flatten Binary Tree to Linked List----------------------------------------------------------------
/*
 Given the root of a binary tree, flatten the tree into a "linked list":

 The "linked list" should use the same TreeNode class where the right child pointer points to the next node in the list and the left child pointer is always null.
 The "linked list" should be in the same order as a pre-order traversal of the binary tree.
 Input: root = [1,2,5,3,4,null,6]
 Output: [1,null,2,null,3,null,4,null,5,null,6]
 */

func flatten(_ root: TreeNode?) {
    func dfs(_ node: TreeNode?) -> TreeNode? {
        guard let node = node else { return nil }
        
        let leftTail = dfs(node.left)
        let rightTail = dfs(node.right)
        
        if let leftTail = leftTail {
            // Save original right subtree
            let right = node.right
            
            // Move left subtree to right
            node.right = node.left
            node.left = nil
            
            // Attach original right subtree
            leftTail.right = right
        }
        
        // Return the tail of the flattened tree
        return rightTail ?? leftTail ?? node
    }
    _ = dfs(root)
}
//------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------------------
//https://leetcode.com/problems/binary-tree-level-order-traversal
func levelOrder(_ root: TreeNode?) -> [[Int]] {
    var finalList = [[Int]]()
    guard let root = root else {
        return finalList
    }
    
    var queue: [TreeNode] = [root]
    
    while !queue.isEmpty {
        var array = [Int]()

        for i in 0..<queue.count {
            let node = queue.removeFirst()  //Try without this and keep number since remove is expensive operation
            array.append(node.val)
            
            if let left = node.left {
                queue.append(left)
            }
            
            if let right = node.right {
                queue.append(right)
            }
        }
        finalList.append(array)
    }
    return finalList
}

print(levelOrder(TreeNode(3, TreeNode(9), TreeNode(20, TreeNode(15), TreeNode(7)))))
//------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------------------
// https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal
func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
    var list = [[Int]]()
    guard let root = root else {
        return list
    }
    
    var queue: [TreeNode] = [root]
    var direction = true
    var frontIndex = 0

    while frontIndex < queue.count {
        var array = [Int]()
        
        for i in frontIndex..<queue.count {

            let node = queue[frontIndex]
            frontIndex += 1

            array.append(node.val)
            
            if let left = node.left {
                queue.append(left)
            }
            
            if let right = node.right {
                queue.append(right)
            }
            
        }
        let subArray = direction ? array: array.reversed()
        list.append(subArray)
        direction.toggle()
        
    }
    return list
}
print(zigzagLevelOrder(TreeNode(3, TreeNode(9), TreeNode(20, TreeNode(15), TreeNode(7)))))
//------------------------------------------------------------------------------------------------------------------------------------------


//---------------------------------------------144. Binary Tree Preorder Traversal-----------------------------------------------------------
//https://leetcode.com/problems/binary-tree-preorder-traversal
func preorderTraversal(_ root: TreeNode?) -> [Int] {
    var array = [Int]()
    
    func iterate(_ root: TreeNode) {
        array.append(root.val)
        
        if let left = root.left {
            iterate(left)
        }
        
        if let right = root.right {
            iterate(right)
        }
    }
    
    if let root = root {
        iterate(root)
    }
    return array
}

print(preorderTraversal(TreeNode(3, TreeNode(9), TreeNode(20, TreeNode(15), TreeNode(7)))))
//------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------173. Binary Search Tree Iterator-------------------------------------------------------------
// https://leetcode.com/problems/binary-search-tree-iterator
class BSTIterator {
    var stack = [TreeNode]()
    init(_ root: TreeNode?) {
        var cur = root
        while cur != nil {
            stack.append(cur!)
            cur = cur!.left
        }
    }
    
    func next() -> Int {
        let node = stack.popLast()!
        var cur = node.right
        while cur != nil {
            stack.append(cur!)
            cur = cur!.left
        }
        return node.val
    }
    
    func hasNext() -> Bool {
        !stack.isEmpty
    }
}
let bSTIterator = BSTIterator(TreeNode(7, TreeNode(3), TreeNode(15, TreeNode(9), TreeNode(20))))
print("BST Iterator Starts:")
print(bSTIterator.next())   // return 3
print(bSTIterator.next())   // return 7
print(bSTIterator.hasNext()) // return True
print(bSTIterator.next())   // return 9
print(bSTIterator.hasNext()) // return True
print(bSTIterator.next())   // return 15
print(bSTIterator.hasNext()) // return True
print(bSTIterator.next())   // return 20
print(bSTIterator.hasNext()) // return False
print("BST Iterator ends:")
//--------------------------------236. Lowest Common Ancestor of a Binary Tree--------------------------------------------------------------
//https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    guard let root = root else {
        return nil
    }
    if root.val == p?.val || root.val == q?.val {
        return root
    }
    let left = lowestCommonAncestor(root.left, p, q)
    let right = lowestCommonAncestor(root.right, p, q)
    
    if left != nil && right != nil {
        return root
    }
    return left ?? right
}
//------------------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------200. Number of Islands---------------------------------------------------------------------------
// https://leetcode.com/problems/number-of-islands
// Run DFS in all direction when found 1 increase the count and sink the land in all directions
func numIslands(_ grid: [[Character]]) -> Int {
    var count = 0
    var grid = grid
    
    func dfs(_ row: Int, _ column: Int) {
        if row < 0 || column < 0 || row >= grid.count || column >= grid[0].count {
            return
        }
        if grid[row][column] == "1" {
            grid[row][column] = "0"
            dfs(row-1, column) // up
            dfs(row, column+1) // right
            dfs(row+1, column) //down
            dfs(row, column-1) //left
        }
    }
    
    
    for i in 0..<grid.count {
        for j in 0..<grid[0].count {
            if grid[i][j] == "1" {
                dfs(i, j)
                count += 1
            }
        }
    }
    
    return count
}

print(numIslands([["1","1","1","1","0"],["1","1","0","1","0"],["1","1","0","0","0"],["0","0","0","0","0"]])) // 1
//---------------------------129. Sum Root to Leaf Numbers--------------------------------------------------------------
//https://leetcode.com/problems/sum-root-to-leaf-numbers
func sumRootToLeaf(_ root: TreeNode?) -> Int {
    func dfs(_ root: TreeNode?, _ currentResult: [Int]) -> Int {
        guard let root = root else {
            return 0
        }
        var newResult = currentResult
        newResult.append(root.val)

        if root.left == nil && root.right == nil {
            return newResult.toInt()
        }
        
        return dfs(root.left, newResult) + dfs(root.right, newResult)
     }
    return dfs(root, [])
}

extension Array where Element == Int {
    func toInt() -> Int {
        self.reduce(0) {
             $0 * 2 + $1
        }
    }
}
print(sumRootToLeaf(TreeNode(1, TreeNode(0, TreeNode(0), TreeNode(1)), TreeNode(1, TreeNode(0), TreeNode(1)))))
//------------------------------------------------------------------------------------------------------------------------------------------


//----------1022. Sum of Root To Leaf Binary Numbers -----------------------------------------------------------
// https://leetcode.com/problems/sum-of-root-to-leaf-binary-numbers
func sumNumbers(_ root: TreeNode?) -> Int {
    func sum(_ root: TreeNode?, _ currentNumber: Int) -> Int {
        guard let root = root else {
            return 0
        }
        let currentNumber = currentNumber * 10 + root.val
        if root.left == nil && root.right == nil {
            return currentNumber
        }
        
        return sum(root.left, currentNumber) + sum(root.right, currentNumber)
    }
    return sum(root, 0)
}

print(sumNumbers(TreeNode(1, TreeNode(2), TreeNode(3))))
//---------------124. Binary Tree Maximum Path Sum-------------------------------------------------------------------
// https://leetcode.com/problems/binary-tree-maximum-path-sum/
func maxPathSum(_ root: TreeNode?) -> Int {
    var maximumValue = Int.min
    func dfs(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        let left = max(0, dfs(root.left)) // Ignore -ve value since it reduces the sum
        let right = max(0, dfs(root.right)) // Ignore -ve value since it reduces the sum
        let value = left+right+root.val
        maximumValue = max(maximumValue, value)
        return root.val + max(left, right) // node should contain only max of left | right sum with root value
    }
    dfs(root)
    return maximumValue
}
//------------------------------------------------------------------------------------------------------------------------------------------

func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
    func build(_ l: Int, _ r: Int) -> TreeNode? {
        if l > r {
            return nil
        }
        
        let mid = l + (r - l) / 2
        let node = TreeNode(nums[mid])
        
        node.left = build(l, mid - 1)
        node.right = build(mid + 1, r)
        
        return node
    }
    
    return build(0, nums.count - 1)
}

print(sortedArrayToBST([-10,-3,0,5,9]))

//------------------------------Kth Smallest Element in a BST ----------------------
// Kth Smallest Element in a BST is the inOrder stack of the kth value
func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
    var stack = [Int]()
    var value = -1
    
    func inOrder(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        
        inOrder(root.left)
        stack.append(root.val)
        
        if stack.count == k {
            value = stack.last!
            return
        }
        inOrder(root.right)
    }
    inOrder(root)
    return value
}

func kthSmallestLowMemory(_ root: TreeNode?, _ k: Int) -> Int {
    var value = -1
    var k = k
    
    func inOrder(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        
        inOrder(root.left)
        
        k -= 1
        
        if 0 == k {
            value = root.val
            return
        }
        inOrder(root.right)
    }
    inOrder(root)
    return value
}

print(kthSmallest(TreeNode(3, TreeNode(1, nil, TreeNode(2)), TreeNode(4)), 1)) // 1

//--------------------------98. Validate Binary Search Tree--------------------------
/*BST Validation With Ranges
(Each node shows: value  [allowed_range])

                         5(-∞,+∞)
                        / \
                 1(-∞,5)   4(5,+∞)
                          / \
                3(5,4) ❌    6(4,+∞)
*/
// When left tree is iterated only right value is updated to parent node val
// When right tree is iterated only left value is updated to parent node val
func isValidBST(_ root: TreeNode?) -> Bool {
    func dfs(_ root: TreeNode?, _ left: Int, _ right: Int) -> Bool {
        guard let node = root else {
            return true
        }
        if node.val <= left {
            return false
        }
        if node.val >= right {
            return false
        }
        
        return dfs(node.left, left, node.val) &&
        dfs(node.right, node.val, right)
    }
    
    return dfs(root, Int.min, Int.max)
}
//--------------------------------------------------------------------------------------
print(isValidBST(TreeNode(5, TreeNode(1), TreeNode(4, TreeNode(3), TreeNode(6))))) // false
print(isValidBST(TreeNode(2, TreeNode(1), TreeNode(3)))) // true

//--------------------------------------------------------------------------------------
//https://leetcode.com/problems/recover-binary-search-tree
/*
 BST inorder sequence is sorted increasing order. Any voilation found (prev > current) means value needs to be swapped.
 */
func recoverTree(_ root: TreeNode?) {
    var previousNode: TreeNode?
    var first: TreeNode?
    var second: TreeNode?
    
    func dfs(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        dfs(root.left)
        
        if let previousNode = previousNode,
           previousNode.val > root.val {
            if first == nil {
                first = previousNode
            }
            second = root //Always update second so that if adjacent values are issues, it will be captured.
        }
        
        previousNode = root
        
        dfs(root.right)
    }
    
    dfs(root)
    
    if let first = first , let second = second {
        let temp = second.val
        second.val = first.val
        first.val = temp
    }
}
//------------------------------------------------------------------------------------------
//---------------------------------113. Path Sum II-----------------------------------------
//https://leetcode.com/problems/path-sum-ii
func pathSum(_ root: TreeNode?, _ targetSum: Int) -> [[Int]] {
    var result = [[Int]]()
    
    func dfs(_ root: TreeNode?, _ currentSum: Int, _ currentResult: [Int]) {
        var currentSum = currentSum
        var currentResult = currentResult
        guard let root = root else {
            return
        }
        currentSum += root.val
        currentResult.append(root.val)
        
        if currentSum == targetSum && root.left == nil && root.right == nil {
            result.append(currentResult)
        } else {
            dfs(root.left, currentSum, currentResult)
            dfs(root.right, currentSum, currentResult)
        }
    }
    dfs(root, 0, [])
    return result
}
//--------------------------------------------------------------------------------------
