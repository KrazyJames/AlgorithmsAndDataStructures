import UIKit

var numbers = [1, 3, 4, 7, 13, 20, 24, 31, 100]

var lowerBound = 0
var middle = 0
var upperBound = numbers.count - 1
var found = false
var term = 7

while(lowerBound <= upperBound) {
    // Find the middle of the array
    middle = (lowerBound + upperBound) / 2
    if(numbers[middle] == term) {
        found = true
        break
    } else if numbers[middle] < term {
        // Choose the right side
        lowerBound = middle + 1
    } else {
        // Choose the left side
        upperBound = middle - 1
    }
}

print(found, term)
