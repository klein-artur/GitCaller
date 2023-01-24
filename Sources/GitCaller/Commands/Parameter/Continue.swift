//
//  File.swift
//  
//
//  Created by Artur Hellmann on 23.01.23.
//

import Foundation

/// Makes a command able to use the `--continue` parameter.
public protocol HasContinueParameter: Parametrable {
    func _continue() -> Self
}

internal class Continue: Parameter {
    var command: String = "--continue"
}

extension HasContinueParameter {
    public func _continue() -> Self {
        return self.withAddedParameter(Continue())
    }
}
