//
//  All.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to use the `--all` parameter.
public protocol HasAllParameter: ParametrableCommandSpec{
    func all() -> Self
}

internal class All: Parameter {
    var command: String = "--all"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasAllParameter {
    public func all() -> Self {
        return self.withAddedParameter(All())
    }
}
