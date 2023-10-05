//
//  Onto.swift
//  
//
//  Created by Artur Hellmann on 11.02.23.
//

import Foundation

/// Makes a command able to use the `--onto` parameter.
public protocol HasOntoParameter: ParametrableCommandSpec{
    func onto() -> Self
}

internal class Onto: Parameter {
    var command: String = "--onto"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasOntoParameter {
    public func onto() -> Self {
        return self.withAddedParameter(Onto())
    }
}
