//
//  File.swift
//  
//
//  Created by Artur Hellmann on 08.01.23.
//

import Foundation

/// Makes a command able to use the `--verbose` parameter.
public protocol HasVerboseParameter: Parametrable {
    func verbose() -> Self
}

internal class Verbose: Parameter {
    var command: String = "--verbose"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasVerboseParameter {
    public func verbose() -> Self {
        return self.withAddedParameter(Verbose())
    }
}
