
// ---------------------------------104. Maximum Depth of Binary Tree------------------------------------------------------
    
func coinChange(_ coins: [Int], _ amount: Int) -> Int {  // [1,2,5]  11
    if amount == 0 {
        return 0
    }
    var dp = Array(repeating: Int.max, count: amount+1)
    dp[0] = 0
    
    for v in 1...amount {
        for c in coins {
            let value = v-c
            if value >= 0 && dp[value] != Int.max {
                dp[v] = min(dp[v], 1+dp[v-c])
            }
        }
    }
    
    if dp[amount] == Int.max {
        return -1
    } else {
        return dp[amount]
    }
}
// ---------------------------------------------------------------------------------------------------------------------------

// ---------------------------------House robber------------------------------------------------------

func rob(_ nums: [Int]) -> Int {
    var dp = nums
    var maxValue = 0
    for i in stride(from: dp.count - 1, through: 0, by: -1) {
        if i == dp.count - 2 {
            dp[i] = max(nums[i], dp[i+1])  // second last house
        } else if i+2 <= dp.count - 1 {
            dp[i] = max(dp[i] + dp[i+2], dp[i+1])
        }
        maxValue = max(maxValue, dp[i])
    }
    return maxValue
}

func rob2(_ nums: [Int]) -> Int {
    var dp = nums
    var maxValue = 0
    for i in stride(from: 0, through: dp.count - 1, by: 1) {
        if i == 1 {
            dp[i] = max(nums[i], dp[i-1])  // second house
        } else if i >= 2 {
            dp[i] = max(nums[i] + dp[i-2], dp[i-1])
        }
        maxValue = max(maxValue, dp[i])
    }
    print(dp)
    return maxValue
}

// ---------------------------------------------------------------------------------------------------------------------------

// -------------------------------------139. Word Break-----------------------------------------------------------------------
//https://leetcode.com/problems/word-break
//bottom up dp and dp[i] = dp[i+word.length] if word matches from i position
func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
    var dp = Array(repeating: false, count: s.count + 1)
    dp[s.count] = true
    var sArray = Array(s)
    
    for i in stride(from: s.count, through: 0, by: -1) {
        for word in wordDict {
            if i + word.count <= s.count && String(sArray[i...(i + word.count-1)]) == word {
                dp[i] = dp[i + word.count]
            }
            if dp[i] {
                break
            }
        }
    }
    
    return dp[0]
}
print(wordBreak("leetcode", ["leet","code"]))

// ---------------------------------------------------------------------------------------------------------------------------

print(coinChange([1,2,5], 11))
print(coinChange([2], 3))
print(rob([2,7,9,3,1])) //12
print(rob([1,2,3,1]))
print(rob([2,1,1,2]))
print(rob2([2,7,9,3,1])) //12
print(rob2([1,2,3,1]))
print(rob2([2,1,1,2]))

// --------------------213. House Robber II -----------------------------------------------------------------------
//https://leetcode.com/problems/house-robber-ii
// rob = max(max(dp[0]..dp[n-1]), max(dp[1]..dp[n-2]))
func robSecond(_ nums: [Int]) -> Int {
    if nums.count == 1 {
        return nums[0]
    } else if nums.count == 2 {
        return max(nums[0], nums[1])
    } else {
        return max(robSum(0, nums.count-1), robSum(1, nums.count))
    }
    
    
    func robSum(_ start: Int, _ end: Int) -> Int {
        var dp = nums
        dp[start] = nums[start]
        dp[start+1] = max(nums[start], nums[start+1])
        var maxValue = max(dp[start], dp[start+1])
        
        for i in (start+2)..<end {
            dp[i] = max(dp[i] + dp[i-2], dp[i-1])
            maxValue = max(dp[i], maxValue)
        }
        return maxValue
    }
}
// ---------------------------------------------------------------------------------------------------------------------------
