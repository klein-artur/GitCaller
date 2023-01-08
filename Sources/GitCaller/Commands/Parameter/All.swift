//
//  All.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to use the `--all` parameter.
public protocol HasAllParameter: Parametrable {
    func all() -> Self
}

internal class All: Parameter {
    var command: String = "--all"
}

extension HasAllParameter {
    public func all() -> Self {
        return self.withAddedParameter(All())
    }
}
