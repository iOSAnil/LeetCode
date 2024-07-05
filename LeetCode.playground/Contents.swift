//Definition for a binary tree node.
import Foundation

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

//Definition for singly-linked list.
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
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


//-------------------------------- 2706. Buy Two Chocolates-----------------------------------------------------------------
class BuyChoclates {
    // Complexity O(n2)
    func buyChoco(_ prices: [Int], _ money: Int) -> Int {
        let sortedPrice = prices.sorted()
        if money - (sortedPrice[0] + sortedPrice[1]) >= 0 {
            return money - (sortedPrice[0] + sortedPrice[1])
        } else {
            return  money
        }
    }
    //Complexity O(n)
    func buyChoco2(_ prices: [Int], _ money: Int) -> Int {
        var a = Int.max
        var b = Int.max

        for p in prices {
            if p < a {
                b = a
                a = p
            } else if p < b {
                b = p
            }
        }
        
        if money - (a+b) >= 0 {
            return money - (a+b)
        } else {
            return  money
        }
    }
}

print(BuyChoclates().buyChoco2([1,2,2], 3)) //output 0
//Explanation: Purchase the chocolates priced at 1 and 2 units respectively. You will have 3 - 3 = 0 units of money afterwards. Thus, we return 0.
// -------------------------------------------------------------------------------------------------------------------------


//-------------------------------- 268. Missing number -----------------------------------------------------------------

class MissingNumber {
    func missingNumber(_ nums: [Int]) -> Int {
        let totalValue = nums.reduce(0, +)
        let totalValueExpected = (nums.count*(nums.count + 1))/2
        return totalValueExpected - totalValue
    }
    
    func missingNumberWithSets(_ nums: [Int]) -> Int {
        Set(0...nums.count).subtracting(Set(nums)).first!
    }
}

print(MissingNumber().missingNumber([9,6,4,2,3,5,7,0,1])) //output 8

/*
 Input: nums = [3,0,1]
 Output: 2
 Explanation: n = 3 since there are 3 numbers, so all numbers are in the range [0,3]. 2 is the missing number in the range since it does not appear in nums.
 */
// -------------------------------------------------------------------------------------------------------------------------

//-------------------------------- 347. Top K Frequent Elements-----------------------------------------------------------------

class TopKFrequent {
    func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
        var dict = [Int: Int]()
        for num in nums {
            dict[num, default: 0] += 1
        }
        return Array(dict.sorted(by: { $0.value > $1.value}).compactMap({$0.0}).prefix(k))
    }
}

print(TopKFrequent().topKFrequent([1,1,1,2,2,3], 2)) //output [1,2]
print(TopKFrequent().topKFrequent([1], 1)) //output [1]

/*
 Example 1:

 Input: nums = [1,1,1,2,2,3], k = 2
 Output: [1,2]
 Example 2:

 Input: nums = [1], k = 1
 Output: [1]

 */

// -------------------------------------------------------------------------------------------------------------------------

//------------------------------------------ 84. Largest Rectangle in Histogram---------------------------------------------

class LargestRectangleAreaBruteForce {
    func largestRectangleArea(_ heights: [Int]) -> Int {
        var maxArea = 0
        for i in 0..<heights.count {
            maxArea = max(maxArea, getAreaForIndex(i, heights: heights))
        }
        return maxArea
    }
    
    private func getAreaForIndex(_ index: Int, heights: [Int]) -> Int {
        let leftwidth = leftWidthSearch(index, heights: heights)
        let rightwidth = rightWidthSearch(index, heights: heights)
        let totalWidth = leftwidth + rightwidth + 1
        return totalWidth*heights[index]
    }
    
    private func leftWidthSearch(_ index: Int, heights: [Int]) -> Int {
        var width = 0
        var i = index - 1
        while i >= 0 {
            if heights[i] >= heights[index] {
                width += 1
            } else {
                return width
            }
            i -= 1
        }
        return width
    }
    
    private func rightWidthSearch(_ index: Int, heights: [Int]) -> Int {
        var width = 0
        var i = index + 1
        while i < heights.count {
            if heights[i] >= heights[index] {
                width += 1
            } else {
                return width
            }
            i += 1
        }
        return width
    }
}

class LargestRectangleArea {
    func largestRectangleArea(_ heights: [Int]) -> Int {
        var stack = [Int]()
        var leftArray = Array(repeating: 0, count: heights.count)
        var rightArray = Array(repeating: 0, count: heights.count)

        for i in stride(from: 0, through: heights.count-1, by: 1) {
            if stack.isEmpty {
                leftArray[i] = 0
                stack.append(i)
            } else {
                while !stack.isEmpty && heights[stack.last!] >= heights[i] {
                    stack.removeLast()
                }
                leftArray[i] = stack.isEmpty ? 0 : stack.last! + 1
                stack.append(i)
            }
        }
        stack.removeAll()
        
        for i in stride(from: heights.count-1, through: 0, by: -1) {
            if stack.isEmpty {
                rightArray[i] = heights.count-1
                stack.append(i)
            } else {
                while !stack.isEmpty && heights[stack.last!] >= heights[i] {
                    stack.removeLast()
                }
                rightArray[i] = stack.isEmpty ? heights.count-1 : stack.last! - 1
                stack.append(i)
            }
        }
        
        var maxArea = 0
        for i in 0..<leftArray.count {
            maxArea = max(maxArea, heights[i]*(rightArray[i]-leftArray[i]+1))
        }
        
        return maxArea
    }
}

print(LargestRectangleArea().largestRectangleArea([2,1,5,6,2,3]))
print(LargestRectangleAreaBruteForce().largestRectangleArea([2,1,5,6,2,3]))

// https://leetcode.com/problems/largest-rectangle-in-histogram/description/
// -------------------------------------------------------------------------------------------------------------------------

//------------------------------------------ 85. Maximal Rectangle----------------------------------------------------------

class MaximumRectangle {
    func maximalRectangle(_ matrix: [[Character]]) -> Int {
        var maxArea = 0
        var heights = [Int]()
        
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                if i == 0 {
                    heights.append(Int(matrix[i][j].description) ?? 0)
                } else if (Int(matrix[i][j].description) ?? 0) != 0 {
                    heights[j] += (Int(matrix[i][j].description) ?? 0)
                } else {
                    heights[j] = 0
                }
            }
            maxArea = max(maxArea, largestRectangleArea(heights))
        }
        return maxArea
    }
    
    func largestRectangleArea(_ heights: [Int]) -> Int {
        var stack = [Int]()
        var leftArray = Array(repeating: 0, count: heights.count)
        var rightArray = Array(repeating: 0, count: heights.count)

        for i in stride(from: 0, through: heights.count-1, by: 1) {
            if stack.isEmpty {
                leftArray[i] = 0
                stack.append(i)
            } else {
                while !stack.isEmpty && heights[stack.last!] >= heights[i] {
                    stack.removeLast()
                }
                leftArray[i] = stack.isEmpty ? 0 : stack.last! + 1
                stack.append(i)
            }
        }
        stack.removeAll()
        
        for i in stride(from: heights.count-1, through: 0, by: -1) {
            if stack.isEmpty {
                rightArray[i] = heights.count-1
                stack.append(i)
            } else {
                while !stack.isEmpty && heights[stack.last!] >= heights[i] {
                    stack.removeLast()
                }
                rightArray[i] = stack.isEmpty ? heights.count-1 : stack.last! - 1
                stack.append(i)
            }
        }
        
        var maxArea = 0
        for i in 0..<leftArray.count {
            maxArea = max(maxArea, heights[i]*(rightArray[i]-leftArray[i]+1))
        }
        
        return maxArea
    }
}

print(MaximumRectangle().maximalRectangle([["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]])) // Output: 6
// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

// -----------------------------------------66. Plus One------------------------------------------------------------------------------------------------------------

class PlusOne {
    func plusOne(_ digits: [Int]) -> [Int] {
        var digits = digits
        var carry = 0
        for i in stride(from: digits.count - 1, through: 0, by: -1) {
            let value = digits[i]
            if i == digits.count - 1  {
                if value + 1 > 9 {
                    digits[i] = 0
                    carry = 1
                } else {
                    digits[i] = value+1
                    carry = 0
                    break
                }
            }  else if carry != 0  {
                if value + carry > 9 {
                    digits[i] = 0
                    carry = 1
                } else {
                    digits[i] = value + carry
                    carry = 0
                    break
                }
            } else {
                break
            }
        }
        
        if carry != 0 {
            digits.insert(carry, at: 0)
        }
        return digits
    }
}
 
print(PlusOne().plusOne([1,1,2]))
print(PlusOne().plusOne([1,1,9]))
print(PlusOne().plusOne([9,9,9]))
print(PlusOne().plusOne([9]))

// -------------------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------12. Integer to Roman-------------------------------------------------------------------------------------------------------
class IntToRoman {
    func intToRoman(_ num: Int) -> String {
        let thousands = ["", "M", "MM", "MMM"]
        let hundreds = ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM" ]
        let tens = ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC" ]
        let ones = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" ]
        
        
        return thousands[(num/1000)] + hundreds[num%1000/100] + tens[num%100/10] + ones[num%10]
    }
}
print(IntToRoman().intToRoman(3999)) //MMMCMXCIX
// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------13. Roman to Integer----------------------------------------------------------------------------------------

class RomanToInt {
    func romanToInt(_ s: String) -> Int {
       
        let hashMap = ["I" : 1,
                       "IV" : 4,"V" : 5,
                       "IX" : 9,"X" : 10,
                       "L" : 50, "XL" : 40,
                       "C" : 100, "XC" : 90,
                       "D" : 500, "CD" : 400,
                       "M" : 1000, "CM" : 900,
        ]
        
        var finalValue = 0
        var index = 0

        while (index < s.count) {
            if index+1 < s.count {
                if let sIndex = s.index(s.startIndex, offsetBy: index, limitedBy: s.endIndex),
                   let eIndex = s.index(s.startIndex, offsetBy: index+1, limitedBy: s.endIndex),
                   let value = hashMap[String(s[sIndex...eIndex])] {
                    index += 2
                    finalValue += value
                }
                else{
                    if let sIndex = s.index(s.startIndex, offsetBy: index, limitedBy: s.endIndex),
                       let value = hashMap[String(s[sIndex...sIndex])] {
                        finalValue += value
                        index += 1
                    }
                }
            }
            else{
                if let sIndex = s.index(s.startIndex, offsetBy: index, limitedBy: s.endIndex),
                   let value = hashMap[String(s[sIndex...sIndex])] {
                    finalValue += value
                    index += 1
                }
            }
        }

        

        return finalValue
    
    }
}
print(RomanToInt().romanToInt("MMMCMXCIX")) //3999
// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------14. Longest Common Prefix---------------------------------------------------------------------------------------
class LongestCommonPrefix {
    func LongestCommonPrefix(_ strs: [String]) -> String {
        var array = [Character]()
        var minLength = 0
        for str in strs {
            minLength = min(minLength, str.count)
        }
        var i = 0
        while i < minLength {
            let firstChar = Array(strs[0])[i]
            var isAllCharSame = false
            for str in strs {
                if str.first != firstChar {
                    return String(array)
                }
            }
            array.append(firstChar)
            i += 1
        }
        return String(array)
    }
}

class LongestCommonPrefixOptimized {
    func LongestCommonPrefix(_ strs: [String]) -> String {
        var finalWord = strs[0]
        while finalWord.count > 0 {
            if !strs.allSatisfy({ $0.hasPrefix(finalWord)}) {
                finalWord.removeLast()
            } else {
                return finalWord
            }
        }
        return finalWord
    }
}

print(LongestCommonPrefix().LongestCommonPrefix(["flower","flow","flight"])) //fl
// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------151. Reverse Words in a String---------------------------------------------------------------------------------------

class ReverseWords {
    func reverseWords(_ s: String) -> String {
        return s.split(separator: " ").reversed().joined(separator: " ")
    }
}
print(ReverseWords().reverseWords("a good   example")) //"example good a"

// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------1431. Kids With the Greatest Number of Candies------------------------------------------------------------------

class KidsWithCandies {
    func kidsWithCandies(_ candies: [Int], _ extraCandies: Int) -> [Bool] {
        let maxCandies = candies.max()!
        return candies.map({ $0 + extraCandies >= maxCandies })
    }
}
print(KidsWithCandies().kidsWithCandies([2,3,5,1,3], 3)) //"example good a"

// ------------------------------------------------------136. Single Number----------------------------------------------------
class SingleNumber {
    func singleNumber(_ nums: [Int]) -> Int {
        nums.reduce(.zero, ^)
    }
}
print(SingleNumber().singleNumber([4,1,2,1,2])) //4
print(SingleNumber().singleNumber([2,2,1])) //1
// ------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------125. Valid Palindrome---------------------------------------------------
class ValidPalindrome {
    func isPalindrome(_ s: String) -> Bool {
        let s = s.lowercased().filter { $0.isLetter || $0.isNumber }
        return s == String(s.reversed())
    }
}
print(ValidPalindrome().isPalindrome("A man, a plan, a canal: Panama")) //true
// ------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------------------------42. Trapping Rain Water---------------------------------------------------
/*
 Start two pointer one from the left of the array and one from the right. Initially water trapping position is zero.
 Start computing the maxLeftValue and maxRightValue at the pointer position.
 let trappingValue = min(maxL, maxR) - height[i] and it should be greater than zero
 The pointer having less value will be moved forward and water trapping position is updated to that index.
 */
class TrappingRainWater {
    func trap(_ height: [Int]) -> Int {
        var leftPointer = 0
        var rightPointer = height.count - 1
        var maxL = height[leftPointer]
        var maxR = height[rightPointer]
        var waterTrapped = 0
        var i = leftPointer
        while leftPointer < rightPointer {
            maxL = max(maxL, height[leftPointer])
            maxR = max(maxR, height[rightPointer])
            let trappingValue = min(maxL, maxR) - height[i]
            if maxL < maxR {
                leftPointer += 1
                i = leftPointer
            } else {
                rightPointer -= 1
                i = rightPointer
            }
            
            waterTrapped += trappingValue > 0 ? trappingValue : 0
            
            
        }
        return waterTrapped
    }
}
print(TrappingRainWater().trap([5,4,1,2]))

// -----------------------------------------------238. Product of Array Except Self------------------------------------
func productExceptSelf(_ nums: [Int]) -> [Int] {
    var result: [Int] = Array(repeating: 1, count: nums.count)
    var left = 1, right = 1
    for index in 0..<nums.count {
        result[index] *= left
        left *= nums[index]
        result[nums.count - 1 - index] *= right
        right *= nums[nums.count - 1 - index]
    }
    return result
}

func productExceptSelfTwoPointer(_ nums: [Int]) -> [Int] {
    var res = [Int](repeating: 1, count: nums.count)
    var prefix = 1
    var postfix = 1

    for i in 0..<nums.count {
        res[i] *= prefix
        prefix *= nums[i]
        res[nums.count-1-i] *= postfix
        postfix *= nums[nums.count-1-i]
    }
    return res
}
print(productExceptSelf([1,2,3,4,5]))
print(productExceptSelfTwoPointer([1,2,3,4,5]))
// ------------------------------------------------------------------------------------------------------------------------------

// -----------------------------------------------55. Jump Game------------------------------------

func canJump(_ nums: [Int]) -> Bool {
    var goal = nums.count - 1
    
    for index in stride(from: nums.count - 1, through: 0, by: -1) {
         if index + nums[index] >= goal {
            goal = index
        }
    }
    return (goal == 0)
}
print(canJump([2,3,1,0,4]))
// ------------------------------------------------------------------------------------------------------------------------------

// -----------------------------------------------290. Word problem------------------------------------

//https://leetcode.com/problems/word-pattern/
class WordPattern {
    func wordPattern(_ pattern: String, _ s: String) -> Bool {
        let array = Array(s.split(separator: " "))
        if pattern.count != array.count {
            return false
        } else {
            return lhs(pattern, s) && rhs(pattern, s)
        }
    }
    
    func rhs(_ pattern: String, _ s: String) -> Bool {
        var dict = [Character: String]()
        let array = Array(s.split(separator: " "))
        var i = 0
        for p in pattern {
            if dict[p] == nil {
                dict[p] = String(array[i])
            } else if dict[p]! != String(array[i]){
                return false
            }
            i += 1
        }
        return true
    }
    
    func lhs(_ pattern: String, _ s: String) -> Bool {
        var dict = [String: Character]()
        let array = Array(s.split(separator: " "))
        let pttrn = Array(pattern)
        var i = 0
        for p in array {
            if dict[String(p)] == nil {
                dict[String(p)] = pttrn[i]
            } else if dict[String(p)]! != pttrn[i] {
                return false
            }
            i += 1
        }
        return true
    }
}
print(WordPattern().wordPattern("abba","dog dog dog dog"))
print(WordPattern().wordPattern("abba","dog cat cat fish"))
// ------------------------------------------------------------------------------------------------------------------------------

// -----------------------------------------------135. Candy----------------------------------------------------
// https://leetcode.com/problems/candy/description/

func candy(_ ratings: [Int]) -> Int {
    var candyDistributed = Array(repeating: 1, count: ratings.count)
    
    for i in 1..<ratings.count {
        if ratings[i-1] < ratings[i] {
            candyDistributed[i] = candyDistributed[i-1] + 1
        }
    }

    for i in stride(from: ratings.count - 1, through: 0, by: -1) {
        if i+1 > ratings.count-1 {
            continue
        } else if candyDistributed[i] <= candyDistributed[i+1] {
            if ratings[i+1] < ratings[i] {
                candyDistributed[i] = candyDistributed[i+1] + 1
            }
        }
    }
    return candyDistributed.reduce(0, +)
}

print(candy([1,0,2])) // 5
// ------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------45. Jump Game II-----------------------------------------------------------
//https://leetcode.com/problems/jump-game-ii
func jump(_ nums: [Int]) -> Int {
    var jumps = 0
    var l = 0
    var r = 0

    while r != nums.count - 1 {
        var farthest = 0
        
        for i in l...r {
            farthest = max(farthest, i+nums[i])
        }
        l = r+1
        r = min(nums.count-1, farthest)

        jumps += 1
    }
    
    return jumps
}
print(jump([2,3,1,1,4])) // 2
// ------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------1306. Jump Game III------------------------------------------------
//https://leetcode.com/problems/jump-game-iii/description/
class JumpGameIII {
    func canReach(_ arr: [Int], _ start: Int) -> Bool {
        var stack = [start]
        var set = Set<Int>()
        
        while !stack.isEmpty {
            let index = stack.removeFirst()
            set.insert(index)
            let rightIndex = index + arr[index]
            if rightIndex <= arr.count - 1 {
                if arr[rightIndex] == 0 {
                    return true
                } else if set.insert(rightIndex).0 == true {
                    stack.append(rightIndex)
                }
            }
            let leftIndex = index - arr[index]

            if leftIndex >= 0 {
                if arr[leftIndex] == 0 {
                    return true
                } else if set.insert(leftIndex).0 == true {
                    stack.append(leftIndex)
                }
            }
        }
        return false
      }
}

print(JumpGameIII().canReach([4,2,3,0,3,1,2], 5)) // true
print(JumpGameIII().canReach([3,0,2,1,2], 2)) // false


// --------------------------------------20. Valid Parentheses---------------------------------------------
//https://leetcode.com/problems/valid-parentheses

func isValid(_ s: String) -> Bool {
       var stack: [String.Element] = []

       for c in s {
           if c == "(" {
               stack.append(")")
           } else if c == "[" {
               stack.append("]")
           } else if c == "{" {
               stack.append("}")
           } else {
               if let bracket = stack.last, bracket == c {
                   stack.popLast()
               } else {
                   return false
               }
           }
       }
       return stack.isEmpty
}
// ------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------35. Search Insert Position-----------------------------------------------------------------

func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var first = 0
    var last = nums.count - 1
    while first <= last {
        let middle = (first + last)/2
        if nums[middle] == target {
            return middle
        } else if nums[middle] > target {
            last = middle - 1
        } else {
            first = middle + 1
        }
    }
    return first
}

print(searchInsert([1,3,5,6], 2)) // 1
// ------------------------------------------------------------------------------------------------------------------------------

// -------------------------------------199. Binary Tree Right Side View-----------------------------------------------------

//https://leetcode.com/problems/binary-tree-right-side-view/
func rightSideView(_ root: TreeNode?) -> [Int] {
    var res = [Int]()
    guard let root = root else {
        return []
    }
    var queue = [root]
    
    while !queue.isEmpty {
        var rightSide: TreeNode?
        let qcount = queue.count
        for _ in 0..<qcount {
            let tree = queue.removeFirst()
            rightSide = tree
            if let leftNode = tree.left {
                queue.append(leftNode)
            }
            if let rightNode = tree.right {
                queue.append(rightNode)
            }
        }
        if let value = rightSide?.val {
            res.append(value)
        }
    }
    return res
}
// ------------------------------------------------------------------------------------------------------------------------------


// -------------------- 100. Same Tree---------------------------------------------------------------------------------------------------------------
//https://leetcode.com/problems/same-tree
func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
      if p == nil && q == nil {
          return true
      }
      return p?.val == q?.val && isSameTree(p?.left, q?.left) && isSameTree(p?.right, q?.right)
}
// ------------------------------------------------------------------------------------------------------------------------------

// -------------------- 226. Invert Tree---------------------------------------------------------------------------------------------------------------
//https://leetcode.com/problems/invert-binary-tree
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root = root else {
        return root
    }
    var stack = [root]
    while !stack.isEmpty {
        let rootNode = stack.removeFirst()
        swap(&rootNode.left, &rootNode.right)
        
        if let left = rootNode.left {
            stack.append(left)
        }
        if let right = rootNode.right {
            stack.append(right)
        }
    }
    return root
}
// ------------------------------------------------------------------------------------------------------------------------------

// -------------------- 101. Symmetric Tree---------------------------------------------------------------------------------------------------------------
func isSymmetric(_ root: TreeNode?) -> Bool {
    if root?.left == nil && root?.right == nil {
        return true
    }
    return root?.left?.val == root?.right?.val && isLeftAndRightNodeEqual(root?.left, root?.right)
}

func isLeftAndRightNodeEqual(_ rootLeft: TreeNode?, _ rootRight: TreeNode?) -> Bool {
    if rootLeft == nil && rootRight == nil {
        return true
    }
    return rootLeft?.val == rootRight?.val && isLeftAndRightNodeEqual(rootLeft?.left, rootRight?.right) && isLeftAndRightNodeEqual(rootLeft?.right, rootRight?.left)
}

// ------------------------------------------------------------------------------------------------------------------------------

// -------------------- 167. Two Sum II - Input Array Is Sorted-------------------------------------------------------------------------------------------------------------
//https://leetcode.com/problems/two-sum-ii-input-array-is-sorted
func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    guard numbers.count >= 2 else {return []}
    var left = 0
    var right = numbers.count - 1
    
    while left <= right {
        if numbers[left] + numbers[right] == target {
            return [left+1, right+1]
        } else if numbers[left] + numbers[right] > target {
            right -= 1
        } else {
            left += 1
        }
    }
    return [0, 0]
}

print(twoSum([2,7,11,15], 9)) // [1,2]
// ------------------------------------------------------------------------------------------------------------------------------
// --------------------------------------134. Gas Station--------------------------------------------------------------
//https://leetcode.com/problems/gas-station/
func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
        if gas.reduce(0, +) < cost.reduce(0, +) {
            return -1
        }
        var total = 0
        var start = 0
    
        for i in 0..<gas.count {
            total += gas[i] - cost[i]
            if total < 0 {
                total = 0
                start = i + 1
            }
        }
    return start
}
print(canCompleteCircuit([1,2,3,4,5], [3,4,5,1,2])) // 3
print(canCompleteCircuit([2,3,4], [3,4,3])) // -1
// ------------------------------------------------------------------------------------------------------------------------------
// --------------------------------------242. Valid Anagram--------------------------------------------------------------
//https://leetcode.com/problems/valid-anagram
func isAnagram(_ s: String, _ t: String) -> Bool {
    var dict1 = [Character: Int]()
    var dict2 = [Character: Int]()
    for ch in s {
        dict1[ch] = (dict1[ch] != nil) ? dict1[ch]!+1 : 1
    }
    for ch in t {
        dict2[ch] = (dict2[ch] != nil) ? dict2[ch]!+1 : 1
    }
    
    for (key,value) in dict1 {
        if dict2[key] != value {
            return false
        }
    }
    
    for (key,value) in dict2 {
        if dict1[key] != value {
            return false
        }
    }
    return true
}

print(isAnagram("anagram","nagaram")) //true
// ------------------------------------------------------------------------------------------------------------------------------

// --------------------------------------219. Contains Duplicate II (EASY)--------------------------------------------------------------

func containsNearbyDuplicate(_ nums: [Int], _ k: Int) -> Bool {
    var left = 0
    var window: Set<Int> = []
    
    for i in 0..<nums.count {
        let right = nums[i]

        if i - left > k {
            window.remove(nums[left])
            left += 1
        }
        if window.contains(right) {
            return true
        } else {
            window.insert(nums[i])
        }
    }
    return false
}
print(containsNearbyDuplicate([1,0,1,1], 1)) // true

// ------------------------------------------------------------------------------------------------------------------------------

// ---------------------------633. Sum of Square Numbers-----------------------------------------------------------------

func judgeSquareSum(_ c: Int) -> Bool {
    var minValue = Int(sqrt(Double(c)))
    
    var hashSet = [Int: Int]()
    for value in 0...minValue {
        hashSet[value*value] = value
    }
    
    for a in 0...minValue {
        if hashSet[c - a*a] != nil {
            return true
        }
    }
    return false
}
print(judgeSquareSum(5))
// ------------------------------------------------------------------------------------------------------------------------------

// ---------------------------48. Rotate Image-----------------------------------------------------------------------------------

class RotateMatrixBy90Degree {
    func rotate(_ matrix: inout [[Int]]) {
        var left = 0
        var right = matrix.count - 1
        
        while left < right {
        for i in 0..<(right - left) {
                var (top, bottom) = (left, right)
                
                let topLeft = matrix[top][left+i] //topLeft
                
                matrix[top][left+i] = matrix[bottom-i][left]
                
                matrix[bottom-i][left] = matrix[bottom][right-i]

                matrix[bottom][right-i] = matrix[top+i][right]

                matrix[top+i][right] = topLeft
            }
            right -= 1
            left += 1
        }
        
     }
}

var matrix = [[1,2,3],[4,5,6],[7,8,9]]
RotateMatrixBy90Degree().rotate(&matrix)
//matrix now becomes [[7,4,1],[8,5,2],[9,6,3]]
// ------------------------------------------------------------------------------------------------------------------------------

// ---------------------------54. Spiral Matrix-----------------------------------------------------------------------------------

func spiralOrder(_ matrix: [[Int]]) -> [Int] {
        guard !matrix.isEmpty else { return [] }
        
        var result = [Int]()
        var top = 0, bottom = matrix.count - 1
        var left = 0, right = matrix[0].count - 1
        
        while left <= right && top <= bottom {
            // Traverse from left to right along the top row
            if right >= left {
                
                for i in left...right {
                    result.append(matrix[top][i])
                }
                top += 1
            }
            
            // Traverse from top to bottom along the right column
            if bottom >= top {
                for i in top...bottom {
                    result.append(matrix[i][right])
                }
                right -= 1
            }
           
            
            if top <= bottom { // Check if there are remaining rows
                // Traverse from right to left along the bottom row
                for i in stride(from: right, through: left, by: -1) {
                    result.append(matrix[bottom][i])
                }
                bottom -= 1
            }
            
            if left <= right { // Check if there are remaining columns
                // Traverse from bottom to top along the left column
                for i in stride(from: bottom, through: top, by: -1) {
                    result.append(matrix[i][left])
                }
                left += 1
            }
        }
        
        return result
    }
// -------------------------------------------------------------------------------------------------------------------------------------
// ---------------------------73. Set Matrix Zeroes-----------------------------------------------------------------------------------
// No new Memory used
class MatrixToZeroes{
    func setZeroes(_ matrix: inout [[Int]]) {
        let rows = matrix.count
        let columns = matrix[0].count
        for i in 0..<rows {
            for j in 0..<columns {
                if matrix[i][j] == 0 {
                    setMaximum(&matrix, i, j)
                }
            }
        }
        resetMaxToZero(&matrix)
    }
    
    func resetMaxToZero(_ matrix: inout [[Int]]) {
        let rows = matrix.count
        let columns = matrix[0].count
        for i in 0..<rows {
            for j in 0..<columns {
                matrix[i][j] = matrix[i][j] == Int.max ? 0 : matrix[i][j]
            }
        }
    }
    
    func setMaximum(_ matrix: inout [[Int]], _ i: Int, _ j: Int) {
        for row in 0..<matrix.count {
            matrix[row][j] = matrix[row][j] == 0 ? 0 : Int.max
        }
        
        for column in 0..<matrix[0].count {
            matrix[i][column] = matrix[i][column] == 0 ? 0 : Int.max
        }
    }
}
var matrix1 = [[0,1,2,0],[3,4,5,2],[1,3,1,5]]
MatrixToZeroes().setZeroes(&matrix1)
print(matrix1) //[[0,0,0,0],[0,4,5,0],[0,3,1,0]]
// -------------------------------------------------------------------------------------------------------------------------------------

// -----------------------------------------------112. Path Sum----------------------------------------------------------------------------
class PathSum {
    func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
        guard let root = root else {
            return false
        }
        return checkBelowTreeSum(root, targetSum)
    }
    
    func isLastNode(_ root: TreeNode?) -> Bool {
        return root?.left == nil && root?.right == nil
    }

    func checkBelowTreeSum(_ root: TreeNode?, _ leftTarget: Int) -> Bool {
        guard let root = root else {
            return false
        }
        let newTarget = leftTarget - root.val
        if isLastNode(root) {
            return newTarget == 0
        }
        return checkBelowTreeSum(root.left, newTarget) || checkBelowTreeSum(root.right, newTarget)
    }
}

let two = TreeNode(2)
let three = TreeNode(3)
let root = TreeNode(1, two, three)
print(PathSum().hasPathSum(root, 3))

// -------------------------------------------------------------------------------------------------------------------------------------

// -------------------------------------------------21. Merge Two Sorted Lists----------------------------------------------------------

func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    // Create a dummy node to simplify the merging process
    let dummy = ListNode(0)
    var current: ListNode? = dummy
    
    // Pointers to traverse the lists
    var l1 = list1
    var l2 = list2
    
    while (l1 != nil && l2 != nil) {
        if l1!.val <= l2!.val {
            current?.next = l1
            l1 = l1?.next
        } else {
            current?.next = l2
            l2 = l2?.next
        }
        
        current = current?.next
    }
    
    if l1 != nil {
        current?.next = l1
    } else if l2 != nil {
        current?.next = l2
    }
    
    return dummy.next
}
// -------------------------------------------------------------------------------------------------------------------------------------

// -------------------------------------------------228. Summary Ranges---------------------------------------------------------

func summaryRanges(_ nums: [Int]) -> [String] {
    var array = [String]()
    if nums.isEmpty {
        return array
    }
    
    var stack = [Int]()
   
    for num in nums {
        if stack.isEmpty {
            stack.insert(num, at: 0)
        } else {
            if stack.last! + 1 != num  {
                if stack.count == 1 {
                    array.append("\(stack[0])")
                } else {
                    array.append("\(stack[0])->\(stack.popLast()!)")
                }
                stack.removeAll()
                stack.insert(num, at: 0)
            } else {
                stack.insert(num, at: stack.count)
            }
        }
    }
    
    if !stack.isEmpty {
        if stack.count == 1 {
            array.append("\(stack[0])")
        } else {
            array.append("\(stack[0])->\(stack.popLast()!)")
        }
    }
    return array
}

print(summaryRanges([0,2,3,4,6,8,9]))
// -------------------------------------------------------------------------------------------------------------------------------------

// -------------------------------------------------289. Game of Life---------------------------------------------------------

func gameOfLife(_ board: inout [[Int]]) {
    for i in 0..<board.count {
        for j in 0..<board[0].count {
            let livingNeighbours = getNeighboursLivingCellsCount(i, j, board)
            switch (board[i][j], livingNeighbours){
            case (0, 3):
                board[i][j] = 10
            case (1, 0..<2), (1, 4...):
                board[i][j] = -10
            default:
                break
            }
        }
    }
    resetBoardValue(&board)
}

func resetBoardValue(_ board: inout [[Int]]) {
    for i in 0..<board.count {
        for j in 0..<board[0].count {
            if board[i][j] == 10 {
                board[i][j] = 1
            } else if board[i][j] == -10 {
                board[i][j] = 0
            }
        }
    }
}

func isLivingValue(_ val: Int?) -> Bool {
    guard let val = val else {
        return false
    }
    return val == 1 || val == -10
}

func getNeighboursLivingCellsCount(_ rowIndex: Int, _ columnIndex: Int, _ board: [[Int]]) -> Int {
    var count = 0
    // Up cells
            
    count += isLivingValue(board[safe: rowIndex-1]?[safe: columnIndex-1]) ? 1 : 0
    count += isLivingValue(board[safe: rowIndex-1]?[safe: columnIndex]) ? 1 : 0
    count += isLivingValue(board[safe: rowIndex-1]?[safe: columnIndex+1]) ? 1 : 0

    
    // left cells
    count += isLivingValue(board[safe: rowIndex]?[safe: columnIndex-1]) ? 1 : 0
    //right cells
    count += isLivingValue(board[safe: rowIndex]?[safe: columnIndex+1]) ? 1 : 0

    //Down cells
    count += isLivingValue(board[safe: rowIndex+1]?[safe: columnIndex-1]) ? 1 : 0
    count += isLivingValue(board[safe: rowIndex+1]?[safe: columnIndex]) ? 1 : 0
    count += isLivingValue(board[safe: rowIndex+1]?[safe: columnIndex+1]) ? 1 : 0
    
    return count
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        get { return self.indices.contains(index) ? self[index] : nil }
    }
}
 
var board = [[0,1,0],[0,0,1],[1,1,1],[0,0,0]]
gameOfLife(&board)
print(board) // [[0,0,0],[1,0,1],[0,1,1],[0,1,0]]
// -------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------2. Add Two Numbers----------------------------------------------------------------------------------
//https://leetcode.com/problems/add-two-numbers
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    let dummy = ListNode(0)
    var currentl1 = l1
    var currentl2 = l2
    
    var head: ListNode? = dummy
    
    var carry = 0
    while currentl1 != nil || currentl2 != nil {
        let val = (currentl1?.val ?? 0) + (currentl2?.val ?? 0) + carry
        head?.next = ListNode(val%10)
        carry = val/10
        head = head?.next
        currentl1 = currentl1?.next
        currentl2 = currentl2?.next
    }
    
    if carry != 0 {
        head?.next = ListNode(carry)
    }
    return dummy.next
}

let resultNode = addTwoNumbers(ListNode(2, ListNode(4, ListNode(3, ListNode(9)))),
                               ListNode(5, ListNode(6, ListNode(6))))
print(resultNode)
// -------------------------------------------------------------------------------------------------------------------------------------

// ------------------------------------61.  Rotate List----------------------------------------------------------------------------------
//https://leetcode.com/problems/rotate-list

func rotateRight(_ head: ListNode?, _ k: Int) -> ListNode? {
    if head == nil {
        return nil
    }
    var length = lengthOfListNode(head)
    let rotate = k%length

    if length == 0 {
        return nil
    }
    if k == 0 || rotate == 0 {
        return head
    }
    
    var shiftingRequiredToCut = length - rotate
    
    var newHead = head
    var lefthead = head
    
    while shiftingRequiredToCut > 0 {
        newHead = newHead?.next
        if shiftingRequiredToCut != 1 {
            lefthead = lefthead?.next
        } else {
            lefthead?.next = nil // cut the head consider this is the last node now
        }
        shiftingRequiredToCut -= 1
    }
    
    let startPointer = newHead
    while newHead?.next != nil {
        newHead = newHead?.next
    }
    
    //Join the last node to the head
    newHead?.next = head
    
    
    while length > 0 {
        newHead = newHead?.next
        length -= 1
    }
    newHead?.next = nil
    
    return startPointer
}
let node: ListNode? = ListNode(1, ListNode(2, ListNode(3, ListNode(4, ListNode(5)))))
print(rotateRight(node, 2))
// -------------------------------------------------------------------------------------------------------------------------------------
