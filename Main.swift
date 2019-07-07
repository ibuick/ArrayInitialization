//
//  main.swift
//  tex
//
//  Created by Buick Wong on 7/6/19.
//  Copyright © 2019 Buick Wong. All rights reserved.
//
import Foundation

let COUNT = 1500000
let BASE  = 150000
let BIAS  = COUNT/BASE

func runTime(for name: String, _ closure: () -> ()) {
    let start = CFAbsoluteTimeGetCurrent()
    closure()
    let diff = CFAbsoluteTimeGetCurrent() - start
    print("Func \(name) takes: \(diff) seconds")
}

var firstArray = Array<Double>(repeating: 0.0, count: COUNT)
var secondArray = Array<Double>(repeating: 0.0, count: COUNT)

runTime(for: "Sequential Create Source Array") {

    firstArray.withUnsafeMutableBufferPointer { arrayBuffer in
        for i in 0..<COUNT {
            arrayBuffer[i] = Double.random(in: 0..<10)
        }
    }

    secondArray.withUnsafeMutableBufferPointer { arrayBuffer in
        for i in 0..<COUNT {
            arrayBuffer[i] = Double.random(in: 0..<10)
        }
    }

}

firstArray = Array<Double>(repeating: 0.0, count: COUNT)
secondArray = Array<Double>(repeating: 0.0, count: COUNT)

runTime(for: "Parallel Create Source Array") {

    DispatchQueue.concurrentPerform(iterations: 1, execute: { idx in

        firstArray.withUnsafeMutableBufferPointer { arrayBuffer in
            DispatchQueue.concurrentPerform(iterations: (BIAS), execute: { idx in
                let base = idx * BASE
                for j in base..<(base + BASE) {
                    arrayBuffer[j] = Double.random(in: 0..<10)
                }
            })
        }

        secondArray.withUnsafeMutableBufferPointer { arrayBuffer in
            DispatchQueue.concurrentPerform(iterations: (BIAS), execute: { idx in
                let base = idx * BASE
                for j in base..<(base + BASE) {
                    arrayBuffer[j] = Double.random(in: 0..<10)
                }
            })
        }

    })

}
