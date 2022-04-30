import UIKit

var numbers = [6, 3, 11, 7, 12, 45, 10, 60, 9, 99]

var minimumIndex = 0

for i in 0..<numbers.count {
    // Assume the min is the first element
    minimumIndex = i
    // Find the min in the rest of the array
    for j in (i+1)..<numbers.count {
        // Update the new min
        if (numbers[j] < numbers[minimumIndex]) {
            minimumIndex = j
        }
    }
    // Swap the positions with the min
    if minimumIndex != i {
        numbers.swapAt(i, minimumIndex)
    }
}

print(numbers)
