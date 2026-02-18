
// ---------------------------------104. Maximum Depth of Binary Tree------------------------------------------------------
class DynamicProgramming {
    
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
}
print(DynamicProgramming().coinChange([1,2,5], 11))
print(DynamicProgramming().coinChange([2], 3))

