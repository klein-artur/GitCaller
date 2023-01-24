//
//  NoFF.swift
//  
//
//  Created by Artur Hellmann on 23.01.23.
//

import Foundation

/// Makes a command able to use the `--no-ff` parameter.
public protocol HasNoFFParameter: Parametrable {
    func noFF() -> Self
}

internal class NoFF: Parameter {
    var command: String = "--no-ff"
}

extension HasNoFFParameter {
    public func noFF() -> Self {
        return self.withAddedParameter(NoFF())
    }
}
