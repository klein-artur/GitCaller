//
//  NoColor.swift
//  
//
//  Created by Artur Hellmann on 05.01.23.
//

import Foundation

/// Makes a command able to use the `--no-color` parameter.
public protocol HasNoColorParameter: ParametrableCommandSpec{
    func noColor() -> Self
}

internal class NoColor: Parameter {
    var command: String = "--no-color"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasNoColorParameter {
    public func noColor() -> Self {
        return self.withAddedParameter(NoColor())
    }
}
