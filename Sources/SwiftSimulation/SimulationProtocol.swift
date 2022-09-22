//
//  Simulation.swift
//  GraphicsDemos_OSX
//
//  Created by Jonathan Wight on 11/30/19.
//  Copyright © 2019 schwa.io. All rights reserved.
//

import Combine
import Everything
import SwiftUI

public protocol SimulationProtocol: ObservableObject {
    func step(delta: TimeInterval) throws
}

public class Simulator<Simulation>: ObservableObject where Simulation: SimulationProtocol {
    @Published
    public private(set) var simulation: Simulation

    @Published
    public var changeCount = 0

    @Published
    public var started = false {
        didSet {
            if started {
                _start()
            }
            else {
                _stop()
            }
        }
    }

    var displayLinkPublisher: DisplayLinkPublisher
    var displayLinkCancellable: AnyCancellable?
    var simulationDidChangeCancellable: AnyCancellable?

    let stepsPerFrame: Int

    public init(simulation: Simulation, stepsPerFrame: Int = 1, start: Bool = false) {
        self.simulation = simulation
        self.stepsPerFrame = stepsPerFrame
        displayLinkPublisher = DisplayLinkPublisher()

        simulationDidChangeCancellable = simulation.objectWillChange.sink { [weak self] _ in
            self?.changeCount += 1
        }
        if start {
            self.start()
        }
    }

    public func start() {
        guard started == false else {
            return
        }
        _start()
        started = true
    }

    public func stop() {
        guard started == true else {
            return
        }
        _stop()
        started = false
    }

    func _start() {
        displayLinkCancellable = displayLinkPublisher
            .receive(on: DispatchQueue.main)
            .sink { update in
                for _ in 0 ..< self.stepsPerFrame {
                    forceTry {
                        try self.simulation.step(delta: update.duration?.seconds ?? 0)
                    }
                }
                // self.changeCount += 1
            }
    }

    func _stop() {
        displayLinkCancellable = nil
    }
}

