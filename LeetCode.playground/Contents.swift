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


// --------------------------------- 215. Kth Largest Element in an Array-----------------------------------------------------

class kThLargestElement {
    func findKthLargestComplexityHighSolution(_ nums: [Int], _ k: Int) -> Int {
        return nums.sorted()[nums.count - k]
    }
    
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        var k = nums.count - k
        var nums = nums
        
        func quickSelect(left: Int, right: Int) -> Int  {
            var pivot = left
            for i in left..<right {
                if nums[i] <= nums[right] {
                    // Swap variables to acheive the left side are all smaller than nums[right]
                    nums.swapAt(i, pivot)
                    pivot += 1
                }
            }
            
            // Swap variables to acheive the nums[pivot] RHS is > values than  nums[pivot] and LHS values < than nums[pivot]
            nums.swapAt(right, pivot)
            
            if pivot < k {
                return quickSelect(left: pivot+1, right: right)
            } else if pivot > k {
                return quickSelect(left: left, right: pivot-1)
            } else {
                return nums[pivot]
            }
        }
        return quickSelect(left: 0, right: nums.count-1)
    }
}

print(kThLargestElement().findKthLargest([3,2,1,5,6,4], 2)) //Output: 5

// -------------------------------------------------------------------------------------------------------------------------

// --------------------------------- 121. best-time-to-buy-and-sell-stock-----------------------------------------------------
// Two pointer approach
class BestTimeToBuySellStock {
    func maxProfit(_ prices: [Int]) -> Int {
        var l: Int = 0
        var r: Int = 0
        var maxP = 0
        while r <= prices.count - 1 {
            if prices[l] < prices[r] {
                maxP = max(maxP, prices[r]-prices[l])
            } else {
                l = r
            }
              r += 1
        }
        return maxP
    }
}

print(BestTimeToBuySellStock().maxProfit([7,1,5,3,6,4])) //Output: 5

//-------------------------------- 122. best-time-to-buy-and-sell-stock-ii--------------------------------------------------
// Dynamic programming approach
class BestTimeToBuySellStock2 {
    func maxProfit(_ prices: [Int]) -> Int {
        var dp = Array(repeating: 0, count: prices.count)
        for i in 1..<prices.count {
            dp[i] = dp[i-1] + max(0, prices[i]-prices[i-1])
        }
        return dp[prices.count - 1]
    }
}
print(BestTimeToBuySellStock2().maxProfit([1,2,3,4,5])) //Output: 4
// -------------------------------------------------------------------------------------------------------------------------


//-------------------------------- 123. best-time-to-buy-and-sell-stock-iii--------------------------------------------------
/*
buyPrice_1 = min(buyPrice_1, price[i])
profit_1 = max(profit_1, price[i]-buyPrice_1)
buyPrice_2 = min(buyPrice_2, price[i]-profit_1)
profit_2 = max(profit_2, price[i]-buyPrice_2)
*/

class BestTimeToBuySellStock3 {
    func maxProfit(_ prices: [Int]) -> Int {
        var buyPrice1 = 100000
        var profit1 = 0
        var buyPrice2 = 100000
        var profit2 = 0
        for p in prices {
            buyPrice1 = min(buyPrice1, p)
            profit1 = max(profit1, p - buyPrice1)
            buyPrice2 = min(buyPrice2, p-profit1)
            profit2 = max(profit2, p - buyPrice2)
        }
        return profit2
    }
}
print(BestTimeToBuySellStock3().maxProfit([3,3,5,0,0,3,1,4])) //Output: 6
// -------------------------------------------------------------------------------------------------------------------------

//-------------------------------- 188. best-time-to-buy-and-sell-stock-IV--------------------------------------------------

class BestTimeToBuySellFourTimes {
    func maxProfit(_ k: Int, _ prices: [Int]) -> Int {
        var buyPrice = Array(repeating: 100000, count: k)
        var profit = Array(repeating: 0, count: k)
        
        for i in 0..<prices.count {
            for j in 0..<k {
                if j == 0 {
                    buyPrice[j] = min(buyPrice[j], prices[i])
                    profit[j] = max(profit[j], prices[i] - buyPrice[j])
                } else {
                    buyPrice[j] = min(buyPrice[j], prices[i]-profit[j-1])
                    profit[j] = max(profit[j], prices[i] - buyPrice[j])
                }
            }
        }
        return profit[k-1]
    }
}
print(BestTimeToBuySellStock3().maxProfit([3,2,6,5,0,3])) //Output: 7
/*
 Explanation: Buy on day 2 (price = 2) and sell on day 3 (price = 6), profit = 6-2 = 4. Then buy on day 5 (price = 0) and sell on day 6 (price = 3), profit = 3-0 = 3.
 */

// -------------------------------------------------------------------------------------------------------------------------
