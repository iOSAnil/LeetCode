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


// ---------------------------------11. rotate-array------------------------------------------------------

class RotateArray {
    //Time complexity is more
    func rotate(_ nums: inout [Int], _ k: Int) {
        var k = k % nums.count

        var newArray = Array(repeating: 0, count: nums.count)
        
        for (index, _) in nums.enumerated() {
            var newIndex = index + k
            if newIndex >= nums.count {
                newIndex -= nums.count
            }
            newArray[newIndex] = nums[index]
        }
        nums = newArray
    }
    
    // Space complexity is more than time complexity
    func rotateByShifting(_ nums: inout [Int], _ k: Int) {
        if k < 0 { return }
        for _ in 0..<k {
            nums.insert(nums[nums.count-1], at: 0)
            nums.removeLast()
        }
    }
    
    func rotateByIndexes(_ nums: inout [Int], _ k: Int) {
        var k = k % nums.count
        /*checking all the valid indexes before accessing in subscript*/
        if nums.count-k < nums.count && nums.count-k > 0 && nums.count-k-1 < nums.count{
            nums = Array(nums[nums.count-k...nums.count-1]) + Array(nums[0...nums.count-k-1])
        }
    }
}
var nums = [1,2,3,4,5,6,7,] //-> [5,6,7,1,2,3,4]
RotateArray().rotateByIndexes(&nums, 3)
print(nums)

// -------------------------------------------------------------------------------------------------------------------------


// --------------------------------- 1143. Longest Common Subsequence-----------------------------------------------------

class LongestCommonSubsequence {
    func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
        var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: text2.count+1), count: text1.count+1)
        
        for i in stride(from: text1.count-1, to: -1, by: -1) {
            for j in stride(from: text2.count-1, to: -1, by: -1) {
                if charEqualAtPosition(text1, i, text2, j) {
                    dp[i][j] = 1 + dp[i+1][j+1]
                } else {
                    dp[i][j] = max(dp[i+1][j], dp[i][j+1])
                }
            }
        }
        return dp[0][0]
    }
    
    func charEqualAtPosition(_ string1: String, _ position1: Int, _ string2: String, _ position2: Int) -> Bool {
        return Array(string1)[position1] == Array(string2)[position2]
    }
}

print(LongestCommonSubsequence().longestCommonSubsequence("abcde", "ace"))

// -------------------------------------------------------------------------------------------------------------------------
