import UIKit

struct Queue<T> {
    var elements: [T] = []

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
        return isEmpty ? nil : elements.removeFirst()
    }
}

class TreeNode<T: Equatable> {
    var value: T
    var children: [TreeNode] = []

    init(_ value: T) {
        self.value = value
    }

    func insert(_ child: TreeNode) {
        self.children.append(child)
    }
}

extension TreeNode {

    enum SearchType {
        case dfs
        case bfs
    }

    // DFS
    func forEachDepthFirst(_ visit: (TreeNode) -> Void) {
        visit(self)
        children.forEach { node in
            node.forEachDepthFirst(visit)
        }
    }

    // BFS
    func forEachBreathFirst(_ visit: (TreeNode) -> Void) {
        visit(self)
        var queue = Queue<TreeNode>()
        children.forEach { node in
            queue.enqueue(node)
        }
        while let node = queue.dequeue() {
            visit(node)
            node.children.forEach { child in
                queue.enqueue(child)
            }
        }
    }

    func search(_ value: T, by type: SearchType = .bfs) -> TreeNode? {
        var result: TreeNode?
        switch type {

        case .dfs:
            forEachDepthFirst { node in
                if node.value == value {
                    result = node
                }
            }
        case .bfs:
            forEachBreathFirst { node in
                if node.value == value {
                    result = node
                }
            }
        }

        return result
    }
}

extension TreeNode: Equatable {
    static func == (lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
        lhs.value == rhs.value
    }
}

let beverages = TreeNode("Breverages")

let hot = TreeNode("Hot")
let cold = TreeNode("Cold")

let tea = TreeNode("Tea")
let coffee = TreeNode("Coffee")

let moka = TreeNode("Moka")
let greenTea = TreeNode("Green Tea")
let blackTea = TreeNode("Black Tea")

let soda = TreeNode("Soda")
let milk = TreeNode("Milk")

let almondsMilk = TreeNode("Almond Milk")
let coconutMilk = TreeNode("Coconut Milk")

beverages.insert(hot)
beverages.insert(cold)

hot.insert(tea)
hot.insert(coffee)

cold.insert(soda)
cold.insert(milk)

coffee.insert(moka)
tea.insert(greenTea)
tea.insert(blackTea)

milk.insert(almondsMilk)
milk.insert(coconutMilk)

print("-----DFS-----")
beverages.forEachDepthFirst { node in
    print(node.value)
}

print("")
print("-----BFS-----")
beverages.forEachBreathFirst { node in
    print(node.value)
}

print("")
print("----Search----")
let result = beverages.search("Moka", by: .dfs)
print(result?.value ?? "Not found")
print(result == moka)
