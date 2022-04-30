import UIKit

var numbers = [10, 3, 5, 12, 9, 20]

for i in 0..<numbers.count {
    for j in 0..<numbers.count {
        if numbers[j] > numbers[i] {
            numbers.swapAt(i, j)
        }
    }
}

print(numbers)
