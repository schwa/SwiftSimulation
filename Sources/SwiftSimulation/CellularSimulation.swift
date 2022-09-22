//
//  Simulation.swift
//  GraphicsDemos
//
//  Created by Jonathan Wight on 9/16/17.
//  Copyright © 2017 schwa.io. All rights reserved.
//

import Everything
import Foundation

public protocol CellularSimulationProtocol: SimulationProtocol {
    associatedtype Cell

    var size: IntSize { get }
    var simulationModel: CellularSimulationModel<Cell> { get }
}

public class CellularSimulationModel<Cell> {
    let size: IntSize
    public var worldGrid: Array2D<Cell>
    public var colorGrid: Array2D<UInt8>

    public init(size: IntSize, initialCell: Cell) {
        self.size = size
        worldGrid = Array2D(repeating: initialCell, size: size)
        colorGrid = Array2D(repeating: 0, size: size)
    }
}

public extension CellularSimulationProtocol {
    func step(count: Int) {
        for _ in 0 ..< count {
            forceTry {
                try step(delta: 0)
            }
        }
    }

    func benchmark(iterations: Int = 10_000) {
        let delta = Everything.benchmark {
            step(count: iterations)
        }
        let iterationsPerSecond = 1 / (delta / Double(iterations))
        print("Iterations per second: \(iterationsPerSecond)")
    }
}
