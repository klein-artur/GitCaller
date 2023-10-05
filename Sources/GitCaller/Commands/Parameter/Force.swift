//
//  Force.swift
//  
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation

/// Makes a command able to use the `--force` parameter.
public protocol HasForceParameter: ParametrableCommandSpec{
    func force() -> Self
}

internal class Force: Parameter {
    var command: String = "--force"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasForceParameter {
    public func force() -> Self {
        return self.withAddedParameter(Force())
    }
}
