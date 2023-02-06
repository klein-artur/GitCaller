//
//  Theirs.swift
//  
//
//  Created by Artur Hellmann on 23.01.23.
//

import Foundation

/// Makes a command able to use the `--theirs` parameter.
public protocol HasTheirsParameter: Parametrable {
    func theirs() -> Self
}

internal class Theirs: Parameter {
    var command: String = "--theirs"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasTheirsParameter {
    public func theirs() -> Self {
        return self.withAddedParameter(Theirs())
    }
}
