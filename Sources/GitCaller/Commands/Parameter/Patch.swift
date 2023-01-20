//
//  Patch.swift
//  
//
//  Created by Artur Hellmann on 20.01.23.
//

import Foundation

/// Makes a command able to use the `--patch` parameter.
public protocol HasPatchParameter: Parametrable {
    func patch() -> Self
}

internal class Patch: Parameter {
    var command: String = "--patch"
}

extension HasPatchParameter {
    public func patch() -> Self {
        return self.withAddedParameter(Patch())
    }
}
