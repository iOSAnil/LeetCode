
// Definition for singly-linked list.
 public class ListNode {
     public var val: Int
     public var next: ListNode?
     public init() { self.val = 0; self.next = nil; }
     public init(_ val: Int) { self.val = val; self.next = nil; }
     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
     
     public func printList() {
         var current: ListNode? = self
         var result: [Int] = []
         while let node = current {
             result.append(node.val)
             current = node.next
         }
         print(result)
     }
 }
//----------------------------148. Sort List------------------------------------
//https://leetcode.com/problems/sort-list/
func sortList(_ head: ListNode?) -> ListNode? {
    if head == nil || head?.next == nil {
        return head
    }
    
    // split the list into two halves
    let left = head
    var right = getMid(head)
    let temp = right?.next
    right?.next = nil
    right = temp
    
    
    let leftList = sortList(left)
    let rightList = sortList(right)
    
    return mergeList(leftList, rightList)
}
    
func getMid(_ head: ListNode?) -> ListNode? {
    var slow = head
    var fast = head?.next
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }
    return slow
}
    
func mergeList(_ list1: ListNode?, _ list2: ListNode?) -> ListNode?{
    var list1 = list1
    var list2 = list2
    let dummy = ListNode()
    var tail = dummy
    while list1 != nil && list2 != nil {
        let list1Value = list1?.val ?? Int.min
        let list2Value = list2?.val ?? Int.min
        if list1Value < list2Value {
            tail.next = list1
            list1 = list1?.next
        } else {
            tail.next = list2
            list2 = list2?.next
        }
        tail = tail.next ?? ListNode(5)
    }
    
    if list1 != nil {
        tail.next = list1
    }
    if list2 != nil {
        tail.next = list2
    }
    return dummy.next
}
//------------------------------------------------------------------------
let list = ListNode(4, ListNode(3, ListNode(2, ListNode(1))))
sortList(list)?.printList()

//---------------------------24. Swap Nodes in Pairs-------------------------
// 1->2->3->4 after swap should be 2->1->4->3
func swapPairs(_ head: ListNode?) -> ListNode? {
    guard let head = head,
          let nextNode = head.next else {
        return head
    }
    
    var prev: ListNode? = head // 1
    var next: ListNode? = nextNode // 2
    var tail: ListNode?   // Last pair after the swap
    
    while (prev != nil && next != nil) {
        var temp = next?.next //3       // nil
        prev?.next = temp  // 1->3.     // 3 -> nil
        next?.next = prev  // 2->3      // 4->3
        
        if let tail = tail {
            tail.next = next
        }
        
        tail = prev   // tail = 1
        prev = temp    // prev = 3
        next = temp?.next // next = 4
    }
    
    if prev != nil && next == nil {
        tail?.next = prev
    }
    return nextNode
}
//--------------------------------------------------- 146. LRU Cache ---------------------------------------
class LRUCache {
    var maxCapacity = 0
    var hashMap: [Int: Node] = [:]
    var left: Node? // LRU
    var right: Node? // Most recent used
    
    class Node {
        var key: Int
        var value: Int
        var next: Node?
        var prev: Node?
        
        init(_ key: Int, _ value: Int) {
            self.key = key
            self.value = value
        }
    }
    
    init(_ capacity: Int) {
        maxCapacity = capacity
        self.left = Node(0, 0)
        self.right = Node(0, 0)
        
        self.left?.next = self.right
        self.right?.prev = self.left
    }
    
    
    private func remove(_ node: Node) {
        let prevNode = node.prev!
        let nextNode = node.next!
        prevNode.next = nextNode
        nextNode.prev = prevNode
    }
    
    //Add the node the right most list
    private func add(_ node: Node) {
        let right = self.right!
        let prevNode = right.prev!
        
        prevNode.next = node
        right.prev = node
        node.next = right
        node.prev = prevNode
    }
    
    func get(_ key: Int) -> Int {
        if let node = hashMap[key] {
            remove(node) // remove the node
            add(node)   // add to right
            return node.value
        }
        return -1
    }
    
    func put(_ key: Int, _ value: Int) {
        if let node = hashMap[key] {
            remove(node)
        }
        hashMap[key] = Node(key, value)
        add(hashMap[key]!)
        
        if hashMap.count > maxCapacity {
            if let lruNode = left?.next {
                remove(lruNode)
                hashMap[lruNode.key] = nil
            }
        }
    }
}
//------------------------------------------------------------------------
