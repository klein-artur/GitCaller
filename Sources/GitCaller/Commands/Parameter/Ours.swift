//
//  Ours.swift
//  
//
//  Created by Artur Hellmann on 23.01.23.
//

import Foundation

/// Makes a command able to use the `--ours` parameter.
public protocol HasOursParameter: Parametrable {
    func ours() -> Self
}

internal class Ours: Parameter {
    var command: String = "--ours"
}

extension HasOursParameter {
    public func ours() -> Self {
        return self.withAddedParameter(Ours())
    }
}
