import UIKit

func factorial(_ number: Int) -> Int {
    if number == 0 {
        // Base case
        return 1
    }
    // Recursive case
    return number * factorial(number - 1)
}

/*
 Call Stack
 factorial(5)
 5 * power(4)
 4 * power(3)
 3 * power(2)
 2 * power(1)
 1 * power(0)
 returns 1
 */
let result = factorial(5)
print(result)


func power(of number: Int, pow: Int) -> Int {
    if pow == 0 {
        // Base case
        return 1
    }
    // Recursive case
    return number * power(of: number, pow: pow - 1)
}

/*
 Call Stack
 2 * power(2,2)
 2 * power(2,1)
 2 * power(2,0)
 returns 1
 */
print(power(of: 2, pow: 3))
