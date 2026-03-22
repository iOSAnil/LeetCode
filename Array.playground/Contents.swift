import UIKit

// -------------------------33. Search in Rotated Sorted Array--------------------------------------------------------

func search(_ nums: [Int], _ target: Int) -> Int {
    var left = 0
    var right = nums.count - 1
    
    while left <= right {
        let mid = left + (right - left)/2
        if nums[mid] == target {
            return mid
        }
        //left array is sorted
        if nums[left] <= nums[mid] {
            if nums[left] <= target && target <= nums[mid] {
                right = mid - 1
            } else {
                left = mid + 1
            }
        } else { // right array is sorted
            if nums[mid] <= target && target <= nums[right] {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
    return -1
}

print(search([4,5,6,7,0,1,2], 0))

// ---------------------------------------------------------------------------------------



//----------------------------------------------------------------------------------------------
//----------------------------81. Search in Rotated Sorted Array II----------------------
func searchRotatedRepeated(_ nums: [Int], _ target: Int) -> Bool {
    var left = 0
    var right = nums.count-1
    
    while left <= right {
        let mid = left + (right - left)/2
        if nums[mid] == target {
            return true
        }
        if nums[left] == nums[mid], nums[mid] == nums[right] {
            left += 1
            right -= 1
        }
        // left array is sorted
        else if nums[left] <= nums[mid] {
            if nums[left] <= target && target < nums[mid] {
                right = mid - 1
            } else {
                left = mid + 1
            }
        } else {
            if nums[mid] < target && target <= nums[right] {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
    return false
}

print("searchRotatedRepeated \(searchRotatedRepeated([2,5,6,0,0,1,2], 0))")
//----------------------------------------------------------------------------------------------
