import UIKit

var greeting = "Hello, playground"


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
        
        // remove left value from window
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
