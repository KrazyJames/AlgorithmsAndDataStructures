import UIKit

class Node<Value> {
    var value: Value
    var next: Node?

    init(_ value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> \(String(describing: next))"
    }
}

struct LinkedList<Value> {
    var head: Node<Value>?
    var tail: Node<Value>?

    var isEmpty: Bool {
        return head == nil
    }

    init() {

    }

    mutating func push(_ value: Value) {
        head = Node(value, next: head)
        if tail == nil {
            tail = head
        }
    }

    mutating func append(_ value: Value) {
        if isEmpty { return push(value) }
        let node = Node(value)
        tail?.next = node
        tail = node
    }

    mutating func insert(_ value: Value, after index: Int) {
        let node = node(at: index)
        node?.next = Node(value, next: node?.next)
    }

    mutating func pop() -> Value? {
        defer {
            // Move the head pointer to the current head's next node
            head = head?.next
            // If it was the only one node in the list, now is empty, remove tail pointer
            if isEmpty {
                tail = nil
            }
        }
        // Return the current head's value before defered operation begins
        return head?.value
    }

    mutating func removeLast() -> Value? {
        // What if it is empty?
        guard let head = head else {
            return nil
        }
        // What if it is the only value in the list?
        guard head.next != nil else {
            return pop()
        }
        var prev = head
        var current = head
        while let next = current.next {
            prev = current
            current = next
        }
        // At this point the current is the tail
        // Remove the tail
        prev.next = nil
        // Replace the tail pointer with the previous-to-tail node
        tail = prev
        // Return the value of the removed tail before lose it
        return current.value
    }

    mutating func remove(after index: Int) -> Value? {
        let node = node(at: index)
        defer {
            // If the next node of the current node is the tail, just move the tail pointer to be the current node
            if node?.next === tail {
                tail = node
            }
            node?.next = node?.next?.next
        }
        // Return the node's next value before defered operation begins
        return node?.next?.value
    }

    func node(at index: Int) -> Node<Value>? {
        var currentIndex = 0
        var currentNode = head
        // Move to the next if there's a next node until the index is found
        while (currentNode != nil && currentIndex < index) {
            currentNode = currentNode?.next
            currentIndex += 1
        }
        return currentNode
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        guard let head = head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}

var list: LinkedList<Int> = .init()

list.append(1)
list.append(2)
list.append(22)
list.append(100)
list.pop()
list.push(12)
list.insert(15, after: 1)
list.removeLast()
list.remove(after: 0)
print(list)
