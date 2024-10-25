// ---------------------------------------------------------------Insert interval ----------------------------------------------------------------

//https://leetcode.com/problems/insert-interval/
func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
    var result = [[Int]]()
    var newInterval = newInterval
    
    for i in 0..<intervals.count {
        if intervals[i][0] > newInterval[1] {
            result.append(newInterval)
            return result + Array(intervals[i...])
        } else if newInterval[0] > intervals[i][1] {
            result.append(intervals[i])
        } else {
            newInterval = [min(newInterval[0], intervals[i][0]), max(newInterval[1], intervals[i][1])]
        }
    }
    result.append(newInterval)
 
    return result
}

// -----------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------56. Merge Intervals------------------------------------------------------------------------
// https://leetcode.com/problems/merge-intervals/
func merge(_ intervals: [[Int]]) -> [[Int]] {

    if intervals.count == 1 {
        return intervals
    } else {
        var intervals = intervals.sorted { a, b in
            return a[0] < b[0]
        }
        var newInterval = intervals[0]
        var i = 0
        var result = [[Int]]()
        
        while (i < intervals.count) {
            if intervals[i][0] <= newInterval[1] {
                newInterval = [min(intervals[i][0], newInterval[0]), max(intervals[i][1], newInterval[1])]
            } else {
                result.append(newInterval)
                newInterval = intervals[i]
            }
            i += 1
        }
        result.append(newInterval)
        return result
    }
}

print(merge([[1,3],[2,6],[8,10],[15,18]])) // [1,6] [8,10],[15,18]
print(merge([[1,4],[4,5]])) // [1,5]
print(merge([[1,3],[2,6],[8,10],[10,11],[11,13]]))  // [1,6] [8,13]
print(merge([[1,4],[0,0]])) // [0, 0][1,4]

// -----------------------------------------------------------------------------------------------------------------------------------------


// ------------------------------------------------------my-calendar-i---------------------------------------------------------------------------
// https://leetcode.com/problems/my-calendar-i/description/
class MyCalendar {
    var intervalTime = [(Int,Int)]()

    init() {
        
    }
    
    func book(_ start: Int, _ end: Int) -> Bool {
        if intervalTime.isEmpty {
            intervalTime.append((start, end))
            return true
        } else {
            var canBeAdded = false
            for i in 0..<intervalTime.count {
                let (starting,ending) = intervalTime[i]   //[10, 20], [20, 30]
                if end <= starting || start >= ending {
                    canBeAdded = true
                } else {
                    canBeAdded = false
                    break
                }
            }
            if canBeAdded {
                intervalTime.append((start, end))
            }
            return canBeAdded

        }
    }
}
let cal = MyCalendar()
for val in [[23,32],[42,50],[6,14],[0,7],[21,30],[26,31],[46,50],[28,36],[0,6],[27,36],[6,11],[20,25],[32,37],[14,20],[7,16],[13,22],[39,47],[37,46],[42,50],[9,17],[49,50],[31,37],[43,49],[2,10],[3,12],[8,14],[14,21],[42,47],[43,49],[36,43]] {
    print(cal.book(val[0], val[1]))
}

[true,true,true,false,false,false,false,false,true,false,false,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
// -----------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------1854. Maximum Population Year---------------------------------------------------------------
//
//https://leetcode.com/problems/maximum-population-year/

func maximumPopulation(_ logs: [[Int]]) -> Int {
    
    let birthYears = logs.compactMap({$0[0]})
    let deathYears = logs.compactMap({$0[1]})
    
    let minBirthYears = birthYears.min() ?? 0
    let maxDeathYears = deathYears.max() ?? 0
    
    var array = Array(repeating: 0, count: maxDeathYears-minBirthYears+2)
    
    for (b,d) in zip(birthYears, deathYears) {
        array[b-minBirthYears] += 1
        array[d-minBirthYears] -= 1
    }

    var maximum = 0
    var populationWithMaxYear = 0
    var value = 0
    
    for year in 0..<array.count {
        value += array[year]
        if maximum < value {
            maximum = value
            populationWithMaxYear = year
        }
    }
    return populationWithMaxYear + minBirthYears
}

print(maximumPopulation([[1950,1961],[1960,1971],[1970,1981]])) //1960 with population 2
// -----------------------------------------------------------------------------------------------------------------------------------------

// --------------------------------------------------2848. Points That Intersect With Cars--------------------------------------------------
//https://leetcode.com/problems/points-that-intersect-with-cars/description/
func numberOfPoints(_ nums: [[Int]]) -> Int {
    let maximum = nums.compactMap({$0[1]}).max() ?? 0
    
    var array = Array(repeating: 0, count: maximum+2)
    
    for index in 0..<nums.count {
        
        if nums[index][0] == nums[index][1] {
            array[nums[index][0]] = 1
        } else {
            for i in nums[index][0]...nums[index][1] {
                array[i] = 1
            }
        }
    }
    
    var indexWithCarPresent = 0
    for value in array {
        if value == 1 {
            indexWithCarPresent += 1
        }
    }
    return indexWithCarPresent
}
// ------------------------------------------------------------------------------------------------------------------------------------------
