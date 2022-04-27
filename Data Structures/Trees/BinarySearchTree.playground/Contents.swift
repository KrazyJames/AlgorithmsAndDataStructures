import UIKit

class BinaryNode<Element> {
    var value: Element
    var left: BinaryNode<Element>?
    var right: BinaryNode<Element>?

    init(_ value: Element) {
        self.value = value
    }

    var min: BinaryNode {
        left ?? self
    }
}

extension BinaryNode: CustomStringConvertible {
    var description: String {
        return treeString(self) { ("\($0.value)", $0.left, $0.right) }
    }
}

struct BinarySearchTree<Element: Comparable> {
    private(set) var root: BinaryNode<Element>?
    init() { }
}

extension BinarySearchTree: CustomStringConvertible {
    var description: String {
        guard let root = root else { return "Empty tree" }
        return String(describing: root)
    }
}

extension BinarySearchTree {
    mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }

    private func insert(from node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element> {
        // If there is no node, return the new node
        guard let node = node else {
            return BinaryNode(value)
        }
        // If the value is lower than the actual node value
        if value < node.value {
            // insert it as the left child
            node.left = insert(from: node.left, value: value)
        } else {
            // otherwhise, insert it as the right child
            node.right = insert(from: node.right, value: value)
        }
        return node
    }

    func contains(_ value: Element) -> Bool {
        var current = root
        // While there's a current node
        while let node = current {
            // ask if the value is in the node
            if node.value == value {
                return true
            }
            // otherwhise check if the value is lower than the current node's value
            if value < node.value {
                current = node.left
            } else {
                // if it is greater, the current node is moved to the right hand child
                current = node.right
            }
        }
        // If not found
        return false
    }

    func path(to value: Element) -> String {
        guard self.contains(value) else {
            return "\(value) is not in this tree"
        }
        var path: [Element] = []
        var current = root
        while let node = current {
            path.append(node.value)
            if node.value == value {
                break
            }
            if value < node.value {
                current = node.left
            } else {
                current = node.right
            }
        }
        return path.map { "\($0)" }.formatted()
    }
}

extension BinarySearchTree {
    mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }

    private func remove(node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element>? {
        // If there's no node
        guard let node = node else {
            return nil
        }
        // If the value is in the current node
        if value == node.value {
            // If it has no children
            if node.left == nil && node.right == nil {
                return nil
            }
            // But if the left child is empty
            if node.left == nil {
                // Move to the right side
                return node.right
            }
            // Otherwhise if there's no right child
            if node.right == nil {
                // Move to the left side
                return node.left
            }
            // At this point, you DO have children (both)
            // The current node's value is updated to the left most value of the right child which will be lower than the current node value
            node.value = node.right!.min.value
            // Then remove from the right hand side the NOW current node value, becuse now it is in a higher point
            node.right = remove(node: node.right, value: node.value)
        // If the value is lower than the current node's one
        } else if value < node.value {
            // Move to the left value and remove it
            node.left = remove(node: node.left, value: value)
        } else {
            // Otherwhise move and remove the right node
            node.right = remove(node: node.right, value: value)
        }
        return node
    }
}

extension BinaryNode {
    // I found this function at: https://stackoverflow.com/questions/43898440/how-to-draw-a-binary-tree-in-console
    private func treeString<Element>(
        _ node: Element,
        reversed: Bool = false,
        isTop: Bool = true,
        using nodeInfo: (Element) -> (String, Element?, Element?))
    -> String {
       // node value string and sub nodes
       let (stringValue, leftNode, rightNode) = nodeInfo(node)
       let stringValueWidth  = stringValue.count
       // recurse to sub nodes to obtain line blocks on left and right
       let leftTextBlock     = leftNode  == nil ? []
                             : treeString(leftNode!,reversed:reversed,isTop:false,using:nodeInfo)
                               .components(separatedBy:"\n")
       let rightTextBlock    = rightNode == nil ? []
                             : treeString(rightNode!,reversed:reversed,isTop:false,using:nodeInfo)
                               .components(separatedBy:"\n")
       // count common and maximum number of sub node lines
        let commonLines       = Swift.min(leftTextBlock.count,rightTextBlock.count)
       let subLevelLines     = max(rightTextBlock.count,leftTextBlock.count)
       // extend lines on shallower side to get same number of lines on both sides
       let leftSubLines      = leftTextBlock
                             + Array(repeating:"", count: subLevelLines-leftTextBlock.count)
       let rightSubLines     = rightTextBlock
                             + Array(repeating:"", count: subLevelLines-rightTextBlock.count)
       // compute location of value or link bar for all left and right sub nodes
       //   * left node's value ends at line's width
       //   * right node's value starts after initial spaces
       let leftLineWidths    = leftSubLines.map{$0.count}
       let rightLineIndents  = rightSubLines.map{$0.prefix{$0==" "}.count  }
       // top line value locations, will be used to determine position of current node & link bars
       let firstLeftWidth    = leftLineWidths.first   ?? 0
       let firstRightIndent  = rightLineIndents.first ?? 0
       // width of sub node link under node value (i.e. with slashes if any)
       // aims to center link bars under the value if value is wide enough
       //
       // ValueLine:    v     vv    vvvvvv   vvvvv
       // LinkLine:    / \   /  \    /  \     / \
       //
        let linkSpacing       = Swift.min(stringValueWidth, 2 - stringValueWidth % 2)
       let leftLinkBar       = leftNode  == nil ? 0 : 1
       let rightLinkBar      = rightNode == nil ? 0 : 1
       let minLinkWidth      = leftLinkBar + linkSpacing + rightLinkBar
       let valueOffset       = (stringValueWidth - linkSpacing) / 2
       // find optimal position for right side top node
       //   * must allow room for link bars above and between left and right top nodes
       //   * must not overlap lower level nodes on any given line (allow gap of minSpacing)
       //   * can be offset to the left if lower subNodes of right node
       //     have no overlap with subNodes of left node
       let minSpacing        = 2
       let rightNodePosition = zip(leftLineWidths,rightLineIndents[0..<commonLines])
                               .reduce(firstLeftWidth + minLinkWidth)
                               { max($0, $1.0 + minSpacing + firstRightIndent - $1.1) }
       // extend basic link bars (slashes) with underlines to reach left and right
       // top nodes.
       //
       //        vvvvv
       //       __/ \__
       //      L       R
       //
       let linkExtraWidth    = max(0, rightNodePosition - firstLeftWidth - minLinkWidth )
       let rightLinkExtra    = linkExtraWidth / 2
       let leftLinkExtra     = linkExtraWidth - rightLinkExtra
       // build value line taking into account left indent and link bar extension (on left side)
       let valueIndent       = max(0, firstLeftWidth + leftLinkExtra + leftLinkBar - valueOffset)
       let valueLine         = String(repeating:" ", count:max(0,valueIndent))
                             + stringValue
       let slash             = reversed ? "\\" : "/"
       let backSlash         = reversed ? "/"  : "\\"
       let uLine             = reversed ? "¯"  : "_"
       // build left side of link line
       let leftLink          = leftNode == nil ? ""
                             : String(repeating: " ", count:firstLeftWidth)
                             + String(repeating: uLine, count:leftLinkExtra)
                             + slash
       // build right side of link line (includes blank spaces under top node value)
       let rightLinkOffset   = linkSpacing + valueOffset * (1 - leftLinkBar)
       let rightLink         = rightNode == nil ? ""
                             : String(repeating:  " ", count:rightLinkOffset)
                             + backSlash
                             + String(repeating:  uLine, count:rightLinkExtra)
       // full link line (will be empty if there are no sub nodes)
       let linkLine          = leftLink + rightLink

       // will need to offset left side lines if right side sub nodes extend beyond left margin
       // can happen if left subtree is shorter (in height) than right side subtree
       let leftIndentWidth   = max(0,firstRightIndent - rightNodePosition)
       let leftIndent        = String(repeating:" ", count:leftIndentWidth)
       let indentedLeftLines = leftSubLines.map{ $0.isEmpty ? $0 : (leftIndent + $0) }
       // compute distance between left and right sublines based on their value position
       // can be negative if leading spaces need to be removed from right side
       let mergeOffsets      = indentedLeftLines
                               .map{$0.count}
                               .map{leftIndentWidth + rightNodePosition - firstRightIndent - $0 }
                               .enumerated()
                               .map{ rightSubLines[$0].isEmpty ? 0  : $1 }
       // combine left and right lines using computed offsets
       //   * indented left sub lines
       //   * spaces between left and right lines
       //   * right sub line with extra leading blanks removed.
       let mergedSubLines    = zip(mergeOffsets.enumerated(),indentedLeftLines)
                               .map{ ( $0.0, $0.1, $1 + String(repeating:" ", count:max(0,$0.1)) ) }
                               .map{ $2 + String(rightSubLines[$0].dropFirst(max(0,-$1))) }
       // Assemble final result combining
       //  * node value string
       //  * link line (if any)
       //  * merged lines from left and right sub trees (if any)
       let treeLines = [leftIndent + valueLine]
                     + (linkLine.isEmpty ? [] : [leftIndent + linkLine])
                     + mergedSubLines

       return (reversed && isTop ? treeLines.reversed(): treeLines)
              .joined(separator:"\n")
    }
}


var tree = BinarySearchTree<Int>()

tree.insert(3)
tree.insert(1)
tree.insert(12)
tree.insert(0)
tree.insert(2)
tree.insert(5)
tree.insert(7)
tree.insert(45)
tree.insert(19)
tree.insert(6)

print(tree)
print(tree.contains(5))
tree.remove(12)
print(tree)
print(tree.path(to: 33))
print(tree.path(to: 7))
