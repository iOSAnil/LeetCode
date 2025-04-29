import UIKit

func letterCombinations(_ n: Int) -> [String] {
    var res = [String]()
    
    func dfs(startIndex: Int, path: [String]) {
        var path = path
        if startIndex == n {
            res.append(path.joined())
            return
        }
        for letter in "ab" {
            path.append(String(letter))
            dfs(startIndex: startIndex + 1, path: path)
            path.removeLast()
        }
    }
    dfs(startIndex: 0, path: [])
    return res
}

print(letterCombinations(2))
