import UIKit

struct Queue<T> {
    private(set) var elements: [T] = []
    var isEmpty: Bool {
        elements.isEmpty
    }
    var first: T? {
        elements.first
    }

    mutating func enqueue(_ element: T) {
        elements.append(element)
    }

    mutating func dequeue() -> T? {
        if isEmpty { return nil }
        return elements.removeFirst()
    }
}

extension Queue: CustomStringConvertible {
    var description: String {
        String(describing: elements)
    }
}

var queue = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
queue.dequeue()
print(queue)
