class TrieNode {
    var children = [Character: TrieNode]()
    var endOfWorld = false
}
class Word {
    var root: TrieNode?
    init(root: TrieNode) {
        self.root = root
    }
    
    func insert(_ word: String) {
        var current = root
        for char in word {
            if current?.children[char] == nil {
                current?.children[char] = TrieNode()
            }
            current = current?.children[char]
        }
        current?.endOfWorld = true
    }
    
}

func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
    var result = [String]()
    // Construct a trie tree with words
    var board = board
    let word = Word(root: TrieNode())
    words.forEach({ word.insert($0)})
    // Search with trie node in the board
    
    var answer = [Character]()
    
    func dfs(_ node: TrieNode?, _ i: Int, _ j: Int) {
        guard let node = node else {
            return
        }
        if node.endOfWorld {
            result.append(String(answer))
            node.endOfWorld = false
        }
        
        if i < 0 ||
            j < 0 ||
            i >= board.count ||
            j >= board[0].count {
            return
        }
        
        let char = board[i][j]
        guard let nextNode = node.children[char] else {
            return
        }
        
        answer.append(board[i][j])
        board[i][j] = "#"
        
        dfs(nextNode, i+1, j)
        dfs(nextNode, i-1, j)
        dfs(nextNode, i, j+1)
        dfs(nextNode, i, j-1)
        board[i][j] = char
        answer.removeLast()
    }
    
    // Start DFS from every cell
    for i in 0..<board.count {
        for j in 0..<board[0].count {
            dfs(word.root, i, j)
        }
    }
    
    return result
}

print(findWords([["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], ["oath","pea","eat","rain"]))
