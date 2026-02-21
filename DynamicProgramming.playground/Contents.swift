
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

print(coinChange([1,2,5], 11))
print(coinChange([2], 3))
print(rob([2,7,9,3,1])) //12
print(rob([1,2,3,1]))
print(rob([2,1,1,2]))
print(rob2([2,7,9,3,1])) //12
print(rob2([1,2,3,1]))
print(rob2([2,1,1,2]))
