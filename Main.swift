//
//  main.swift
//  tex
//
//  Created by Buick Wong on 7/6/19.
//  Copyright © 2019 Buick Wong. All rights reserved.
//
import Foundation

let COUNT = 1500000
let BASE  = 15000
let BIAS  = COUNT/BASE

func runTime(for name: String, _ closure: () -> ()) {
    let start = CFAbsoluteTimeGetCurrent()
    closure()
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Func \(name) takes: \(diff) seconds")
}

var firstArray = Array<Double>(repeating: 0.0, count: COUNT)
var secondArray = Array<Double>(repeating: 0.0, count: COUNT)

runTime(for: "Parallel Create Source Array") {

    DispatchQueue.concurrentPerform(iterations: 1, execute: { idx in

        firstArray.withUnsafeMutableBufferPointer { arrayBuffer in
            DispatchQueue.concurrentPerform(iterations: (BIAS), execute: { idx in
                let base = idx * BASE
                var output: CDouble = 0.0
                for j in base..<(base + BASE) {
                    rdrand64_step(&output)
                    arrayBuffer[j] = output
                }
            })
        }

        secondArray.withUnsafeMutableBufferPointer { arrayBuffer in
            DispatchQueue.concurrentPerform(iterations: (BIAS), execute: { idx in
                let base = idx * BASE
                var output: CDouble = 0.0
                for j in base..<(base + BASE) {
                    rdrand64_step(&output)
                    arrayBuffer[j] = output
                }
            })
        }

    })

}

print(firstArray[0..<5])
print(secondArray[0..<5])

firstArray = Array<Double>(repeating: 0.0, count: COUNT)
secondArray = Array<Double>(repeating: 0.0, count: COUNT)

runTime(for: "Sequential Create Source Array") {

    firstArray.withUnsafeMutableBufferPointer { arrayBuffer in
        var output: CDouble = 0.0
        for i in 0..<COUNT {
            rdrand64_step(&output)
            arrayBuffer[i] = output
        }
    }

    secondArray.withUnsafeMutableBufferPointer { arrayBuffer in
        var output: CDouble = 0.0
        for i in 0..<COUNT {
            rdrand64_step(&output)
            arrayBuffer[i] = output
        }
    }

}




