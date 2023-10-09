//
//  Init.swift
//
//
//  Created by Artur Hellmann on 09.10.23.
//

import Foundation

/// Makes a command able to use the `--init` parameter.
public protocol HasInitParameter: ParametrableCommandSpec{
    func initialize() -> Self
}

internal class Init: Parameter {
    var command: String = "--init"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasInitParameter {
    public func initialize() -> Self {
        return self.withAddedParameter(Init())
    }
}
