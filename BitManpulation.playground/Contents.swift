import UIKit

//----------------------------------------------------------------------------------------------------------------------
// calculator xor which gives sum without carry
// Calculate & with left shift 1 position to give carry and run loop till carry is zero
func addBinary(_ a: String, _ b: String) -> String {
    var x = Int(a, radix: 2)!
    var y = Int(b, radix: 2)!

    while y != 0 {
        let sum = x ^ y
        let carry = (x & y) << 1
        x = sum
        y = carry
    }
    return String(x, radix: 2)
}

print(addBinary("1010", "1011"))
//----------------------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------------------
//https://leetcode.com/problems/reverse-bits
// Add 1 to each position of the bit one by one and see if & is not zero which is confirming the current position in number contains 1
// put this 1 to 31 - i position and push the mask to 1 left operator for next bit
func reverseBits(_ n: Int) -> Int {
    var ans = 0;
    var mask = 1
    
    for i in 0..<32 {
        if mask&n != 0 {
            ans += (1 << (31-i))
        }
        mask = mask << 1
    }
    return ans
}
print(reverseBits(8))
//----------------------------------------------------------------------------------------------------------------------

//-------https://leetcode.com/problems/number-of-1-bits-----------------------------------------------------------------
// Remove 1 at position starting from highest bit ny doing & with (n-1) value
func hammingWeight(_ n: Int) -> Int {
    var ans = 0
    var n = n
    while n != 0 {
        ans += 1
        n = n&(n-1)
    }
    return ans
}
print(hammingWeight(11))
print(hammingWeight(128))
//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
//https://leetcode.com/problems/single-number-ii/
//Given an integer array nums where every element appears three times except for one, which appears exactly once. Find the single element and return it.
// Intuition: After 3 times ones is reset
func singleNumber(_ nums: [Int]) -> Int {
    var ones = 0
    var twos = 0
    for n in nums {
        ones = (ones ^ n) & ~twos
        twos = (twos ^ n) & ~ones
    }
    return ones
}
//----------------------------------------------------------------------------------------------------------------------
//Given two integers left and right that represent the range [left, right], return the bitwise AND of all numbers in this range, inclusive.
/* When we look at consecutive numbers in binary representation, we notice a pattern. As numbers increment, the rightmost bits keep flipping while the leftmost bits remain stable for a while. For example, looking at numbers 5 to 7:

5: 101
6: 110
7: 111
The rightmost bit changes from 1→0→1, the middle bit changes from 0→1→1, but the leftmost bit stays at 1. When we AND all these numbers together, any bit position that changes even once will become 0 in the final result.

The key observation is that the result of AND-ing a range of numbers is essentially finding their common binary prefix. Once a bit position differs between any two numbers in the range, that bit and all bits to its right will become 0 in the final answer.

Instead of AND-ing all numbers one by one, we can directly find this common prefix. The trick is to recognize that right & (right - 1) removes the rightmost set bit from right. By repeatedly applying this operation, we're essentially removing the differing rightmost bits until right becomes small enough that it shares the same prefix with left.

Think of it this way: the numbers left and right differ in some rightmost bits. By continuously stripping away the rightmost 1-bits from right, we're moving towards the largest number that has the same prefix as left. Once right becomes less than or equal to left, we've found our common prefix, which is the answer to our bitwise AND operation.

This approach is efficient because instead of iterating through potentially millions of numbers in the range, we only need to remove a few bits (at most the number of bits in the binary representation).*/
func rangeBitwiseAnd(_ left: Int, _ right: Int) -> Int {
    var right = right
    while left < right {
        right = right & (right - 1)
    }
    return right
}
//----------------------------------------------------------------------------------------------------------------------
