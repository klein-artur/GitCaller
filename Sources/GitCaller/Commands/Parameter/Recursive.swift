//
//  Recursive.swift
//
//
//  Created by Artur Hellmann on 09.10.23.
//

import Foundation

/// Makes a command able to use the `--recursive` parameter.
public protocol HasRecursiveParameter: ParametrableCommandSpec{
    func recursive() -> Self
}

internal class Recursive: Parameter {
    var command: String = "--recursive"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasRecursiveParameter {
    public func recursive() -> Self {
        return self.withAddedParameter(Recursive())
    }
}
