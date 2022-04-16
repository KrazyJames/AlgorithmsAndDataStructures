import UIKit

struct Stack<Element> {
    private var storage: [Element] = []

    mutating func push(_ element: Element) {
        storage.append(element)
    }

    mutating func pop() -> Element? {
        storage.popLast()
    }
}

extension Stack: CustomStringConvertible {
    var description: String {
        let top = "----top----\n"
        let bottom = "\n---bottom---"
        let stackedElements = storage.map { element in
            "\(element)"
        }.reversed().joined(separator: "\n")
        return top + stackedElements + bottom
    }
}

var stack = Stack<Int>()

stack.push(1)
stack.push(2)
stack.push(3)
stack.push(4)
stack.pop()

print(stack)

