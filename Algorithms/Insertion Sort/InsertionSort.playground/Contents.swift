import UIKit

var numbers = [6, 3, 11, 7, 12, 45, 10, 60, 9]

for (i, currentNumber) in numbers.enumerated() {
    // Start at the second position
    guard i > 0 else { continue }
    // Compare against the numbers behind
    for (j, behindNumber) in numbers[0..<i].enumerated() {
        // If the current number is less than, should be first
        if currentNumber < behindNumber {
            // Swap the position with the smallest one
            numbers.swapAt(i, j)
        }
    }
}

print(numbers)
