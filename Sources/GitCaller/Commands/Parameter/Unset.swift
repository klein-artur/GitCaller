//
//  Unset.swift
//  
//
//  Created by Artur Hellmann on 02.02.23.
//

import Foundation

/// Makes a command able to use the `--unset` parameter.
public protocol HasUnsetParameter: Parametrable {
    func unset() -> Self
}

internal class Unset: Parameter {
    var command: String = "--unset"
}

extension HasUnsetParameter {
    public func unset() -> Self {
        return self.withAddedParameter(Unset())
    }
}

