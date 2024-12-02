import UIKit


//----------------------------------------------------239. Sliding Window Maximum-----------------------------------------------------------------
// https://leetcode.com/problems/sliding-window-maximum/description/
// There is a sliding window of size k which is moving from the very left of the array to the very right. You can only see the k numbers in the window. find max of each window.
func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    var output: [Int] = []
    var q: [Int] = []
    var r = 0
    
    while r < nums.count {
        // pop smaller values from q
        while !q.isEmpty && nums[q.last!] < nums[r] {
            q.removeLast()
        }
        q.append(r)
        
        // remove left value from window ( when first element is of index less than or equal exisitng window)
        if r >= k && q.first == r - k {
            q.removeFirst()
        }
        
        if r >= k - 1 {
            output.append(nums[q.first!])
        }
        r += 1
    }
    
    return output
}

print(maxSlidingWindow([1,3,-1,-3,5,3,6,7], 3))
print(maxSlidingWindow([1], 1))


//----------------------------------------------------496. Next Greater Element I------------------------------------------------------------------
//https://leetcode.com/problems/next-greater-element-i

func nextGreaterElement(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
    var numberIndexDict = [Int: Int]()
    for i in 0..<nums1.count {
        numberIndexDict[nums1[i]] = i
    }
    
    var output = Array(repeating: -1, count: nums1.count)
    var stack = [Int]()

    for j in 0..<nums2.count {
        while !stack.isEmpty && stack.last! < nums2[j] {
            let lastValue = stack.popLast()!
            if let key = numberIndexDict[lastValue] {
                output[key] = nums2[j]
            }
        }
        
        stack.append(nums2[j])
    }
    
    return output
}
print(nextGreaterElement([4,1,2], [1,3,4,2]))
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------503. Next Greater Element II--------------------------------------------------------------------
//https://leetcode.com/problems/next-greater-element-ii


func nextGreaterElements(_ nums: [Int]) -> [Int] {
      var newNum = nums + nums
      var output = Array(repeating: -1, count: newNum.count)
      
      var stack = [Int]()
      
      var intialSearchIndex = 0
      while intialSearchIndex < newNum.count {
          while !stack.isEmpty && newNum[stack.last!] < newNum[intialSearchIndex] {
              let poppedValue = stack.popLast()!
              output[poppedValue] = newNum[intialSearchIndex]
          }
          stack.append(intialSearchIndex)
          
          intialSearchIndex += 1
      }
      return Array(output[0..<nums.count])
  }

print(nextGreaterElements([1,2,1])) // [2,-1, 2]
//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------321. Create Maximum Number--------------------------------------------------------------------
//https://leetcode.com/problems/create-maximum-number/description

class MaxNumber {
    func maxNumber(_ nums1: [Int], _ nums2: [Int], _ k: Int) -> [Int] {
        // Helper function to get the maximum subarray of given length
        func maxSubarray(_ nums: [Int], _ length: Int) -> [Int] {
            var stack = [Int]()
            var index = 0
            
            while index < nums.count {
                let num = nums[index]
                let itemsLeftToProcessInArray = nums.count - index
                while !stack.isEmpty && stack.last! < num && stack.count + itemsLeftToProcessInArray > length {
                    stack.removeLast()
                }
                if stack.count < length {
                    stack.append(num)
                }
                index += 1
            }
            return stack
        }
        
        // Helper function to merge two arrays into the lexicographically largest sequence
        func merge(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
            var result = [Int]()
            var i = 0
            var j = 0
            
            while i < nums1.count || j < nums2.count {
                if i < nums1.count && (j >= nums2.count || nums1[i] > nums2[j] || (nums1[i] == nums2[j] && Array(nums1[i...]) > Array(nums2[j...]))) {
                    result.append(nums1[i])
                    i += 1
                } else {
                    result.append(nums2[j])
                    j += 1
                }
            }
            return result
        }
        
        var bestResult = [Int]()
        
        // Iterate over all possible splits of k between nums1 and nums2
        for i in 0...k {
            if i <= nums1.count && k - i <= nums2.count {
                let subarray1 = maxSubarray(nums1, i)
                let subarray2 = maxSubarray(nums2, k - i)
                let candidate = merge(subarray1, subarray2)
                if candidate > bestResult {
                    bestResult = candidate
                }
            }
        }
        
        return bestResult
    }
}
extension Array where Element == Int {
    static func >(lhs: [Int], rhs: [Int]) -> Bool {
        // Compare elements lexicographically
        var minLength = lhs.count
            
        if lhs.count > rhs.count {
            minLength = rhs.count
        }
        
        for i in 0..<minLength {
            if lhs[i] < rhs[i] {
                return false
            } else if lhs[i] > rhs[i] {
                return true
            }
        }
        
        // If all compared elements are equal, the shorter array is considered less
        return lhs.count > rhs.count
    }
}

print(MaxNumber().maxNumber([3,4,6,5], [9,1,2,5,8,3], 5)) // [9,8,6,5,3]

//----------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------862. Shortest Subarray with Sum at Least K------------------------------------------------------
//https://leetcode.com/problems/shortest-subarray-with-sum-at-least-k/description/

func shortestSubarray(_ nums: [Int], _ k: Int) -> Int {
    var dq: [(Int, Int)] = [] // (index, sum)
    var sum: Int = 0
    var shortest: Int = Int.max
    
    for i in 0..<nums.count {
        sum += Int(nums[i])
        if sum >= k {
            shortest = min(shortest, Int(i + 1)) // Sum from start to i-th index
        }
        
        // Reduce window size to find minimum window with sum >= k
        var curr: (Int, Int) = (Int.min, Int.min)
        while !dq.isEmpty && (sum - Int(dq.first!.1) >= k) {
            curr = dq.removeFirst()
            // Calculate new shortest (if possible)
            if curr.1 != Int.min {
                shortest = min(shortest, Int(i) - curr.0)
            }
        }
        
        // Maintain monotonically non-decreasing order of deque
        while !dq.isEmpty && sum <= Int(dq.last!.1) {
            dq.removeLast()
        }
        dq.append((i, Int(sum))) // Push i-th sum
    }
    
    return shortest == Int.max ? -1 : Int(shortest)
}
//----------------------------------------------------------------------------------------------------------------------------------------------------
