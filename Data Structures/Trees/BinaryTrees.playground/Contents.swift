import UIKit

class BinaryNode<Element> {
    var value: Element
    var left: BinaryNode?
    var right: BinaryNode?

    init(_ value: Element) {
        self.value = value
    }
}

extension BinaryNode {
    // LNR
    func inOrderTraversal(visit: (Element) -> Void) {
        left?.inOrderTraversal(visit: visit)
        visit(value)
        right?.inOrderTraversal(visit: visit)
    }

    // LRN
    func postOrderTraversal(visit: (Element) -> Void) {
        left?.postOrderTraversal(visit: visit)
        right?.postOrderTraversal(visit: visit)
        visit(value)
    }

    // NLR
    func preOrderTraversal(visit: (Element) -> Void) {
        visit(value)
        left?.preOrderTraversal(visit: visit)
        right?.preOrderTraversal(visit: visit)
    }
}

let seven = BinaryNode(7)
let nine = BinaryNode(9)
let zero = BinaryNode(0)
let one = BinaryNode(1)
let eight = BinaryNode(8)
let five = BinaryNode(5)

seven.left = one
seven.right = nine
nine.left = eight
one.left = zero
one.right = five

print("In-Order Traversal")
seven.inOrderTraversal { value in
    print(value)
}
print("Post-Order Traversal")
seven.postOrderTraversal { value in
    print(value)
}
print("Pre-Order Traversal")
seven.preOrderTraversal { value in
    print(value)
}
