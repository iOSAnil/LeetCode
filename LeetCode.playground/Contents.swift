//Definition for a binary tree node.

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

// ---------------------------------104. Maximum Depth of Binary Tree------------------------------------------------------
class MaximumDepthOfBinaryTree {
    func maxDepth(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        } else {
            return 1 + max(maxDFS(root?.left, 1), maxDFS(root?.right, 1))
        }
    }
    
    func maxDFS(_ root: TreeNode?, _ depthlevel: Int) -> Int{
        if root == nil {
            return 0
        }
        if root?.left == nil && root?.right == nil {
            return depthlevel
        } else {
            return max(maxDFS(root?.left, depthlevel + 1), maxDFS(root?.right, depthlevel + 1))
        }
     }
    
    func arrayToTree(_ arr: [Int?], _ index: Int) -> TreeNode? {
        guard index < arr.count else {
            return nil
        }
        
        var node: TreeNode?
        if let value = arr[index] {
            node = TreeNode(value)
        }
        
        node?.left = arrayToTree(arr, 2 * index + 1)
        node?.right = arrayToTree(arr, 2 * index + 2)

        return node
    }
}

let tree = MaximumDepthOfBinaryTree().arrayToTree([3,9,20,nil,nil,15,7], 0)
let treeDepth = MaximumDepthOfBinaryTree().maxDepth(tree)

// -------------------------------------------------------------------------------------------------------------------------


// ---------------------------------1768. Merge Strings Alternately ------------------------------------------------------

class MergeStringAlternately {
    func mergeAlternately(_ word1: String, _ word2: String) -> String {
        let word1Array = Array(word1)
        let word2Array = Array(word2)
        let big = max(word1Array.count, word2Array.count)
        var result = [Character]()
        for i in 0..<big {
            if i < word1.count {
                result.append(word1Array[i])
            }
            if i < word2.count {
                result.append(word2Array[i])
                
            }
        }
        return String(result)
    }
}
    
let mergeAlternately = MergeStringAlternately().mergeAlternately("abc", "pqr")
print(mergeAlternately)
// Note - String.count method takes longer in ms than an Array(string).count
// -------------------------------------------------------------------------------------------------------------------------



// ---------------------------------11. Container With Most Water------------------------------------------------------

class ContainerWithMostWater {
    func maxArea(_ height: [Int]) -> Int {
        var area = 0
        var left = 0
        var right = height.count - 1
        
        while left < right {
            let leftHeight = height[left]
            let rightHeight = height[right]
            let currentArea = min(leftHeight, rightHeight)*(right-left)
            area = max(area, currentArea)
            
            if leftHeight > rightHeight {
                right -= 1
            } else {
                left += 1
            }
        }
        return area
    }
}

print(ContainerWithMostWater().maxArea([1,8,6,2,5,4,8,3,7]))
// -------------------------------------------------------------------------------------------------------------------------


