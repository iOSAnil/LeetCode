
//------------------------169. Majority Element------------------------
// https://leetcode.com/problems/majority-element
func majorityElement(_ nums: [Int]) -> Int {
    var number: Int = 0
    var count = 0
    for num in nums {
        if num == number {
            count += 1
        } else if count == 0 {
            number = num
            count = 1
        } else {
            count -= 1
        }
    }
    return number
}

print("Majority element test \(majorityElement([2,2,1,1,1,2,2]))")
//-----------------------------------------------------------------------
//-----------------------229. Majority Element II------------------------
// https://leetcode.com/problems/majority-element
// Given an integer array of size n, find all elements that appear more than ⌊ n/3 ⌋ times.
func majorityElement2(_ nums: [Int]) -> [Int] {
    var candidate1 = 0
    var candidate2 = 0
    var count1 = 0
    var count2 = 0

    for num in nums {
        if num == candidate1 {
            count1 += 1
        } else if num == candidate2 {
            count2 += 1
        } else if count1 == 0 {
            candidate1 = num
            count1 = 1
        } else if count2 == 0 {
            candidate2 = num
            count2 = 1
        } else {
            count1 -= 1
            count2 -= 1
        }
    }

    count1 = 0
    count2 = 0
    var threshold = nums.count / 3
    var result = [Int]()
    for num in nums {
        if num == candidate1 { count1 += 1}
        else if num == candidate2 { count2 += 1}
    }

    if count1 > threshold {
        result.append(candidate1)
    }
    if count2 > threshold {
        result.append(candidate2)
    }
    return result
}
print("Majority element test \(majorityElement2([3,2,3,2,1,2,3]))")

//-----------------------------------------------------------------------
