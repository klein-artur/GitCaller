//
//  File.swift
//  
//
//  Created by Artur Hellmann on 23.01.23.
//

import Foundation

/// Makes a command able to use the `--continue` parameter.
public protocol HasContinueParameter: ParametrableCommandSpec{
    func _continue() -> Self
}

internal class Continue: Parameter {
    var command: String = "--continue"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasContinueParameter {
    public func _continue() -> Self {
        return self.withAddedParameter(Continue())
    }
}
