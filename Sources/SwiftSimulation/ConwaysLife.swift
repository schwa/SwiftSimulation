//
//  Life.swift
//  GraphicsDemos
//
//  Created by Jonathan Wight on 4/19/17.
//  Copyright © 2017 schwa.io. All rights reserved.
//

import CoreGraphics
import Everything
import Foundation

public class Life: CellularSimulationProtocol {
    public var size: IntSize
    public var simulationModel: CellularSimulationModel<Life.Cell>

    private var newBuffer: Array2D<Life.Cell>

    public enum Cell {
        case empty
        case filled
        case died
        case born

        var alive: Bool {
            switch self {
            case .filled, .born:
                return true
            default:
                return false
            }
        }
    }

    public init(size: IntSize = IntSize(width: 128, height: 128)) {
        self.size = size

        simulationModel = CellularSimulationModel<Life.Cell>(size: size, initialCell: .empty)
        newBuffer = Array2D<Cell>(repeating: .empty, size: size)
    }

    public func step(delta: TimeInterval) throws {
        for (index, value) in simulationModel.worldGrid.indexed() {
            var count = 0
            for x in max(index.x - 1, 0) ... min(index.x + 1, simulationModel.worldGrid.size.width - 1) {
                for y in max(index.y - 1, 0) ... min(index.y + 1, simulationModel.worldGrid.size.height - 1) {
                    if x == index.x && y == index.y {
                        continue
                    }
                    if simulationModel.worldGrid[x, y].alive == true {
                        count += 1
                    }
                }
            }

            switch (value.alive, count) {
            case (true, 2), (true, 3):
                newBuffer[index] = .filled
            case (false, 3):
                newBuffer[index] = .born
            case (true, _):
                newBuffer[index] = .died
            default:
                newBuffer[index] = .empty
            }
        }

        swap(&newBuffer, &simulationModel.worldGrid)
    }
}

extension Life.Cell: ColorConvertible {
    public var color: CGColor {
        switch self {
        case .empty:
            return .black
        case .filled:
            return .white
        case .died:
            return CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        case .born:
            return CGColor(red: 0, green: 1, blue: 0, alpha: 1)
        }
    }
}
