//
//  Quiet.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to use the `--quiet` parameter.
public protocol HasQuietParameter: Parametrable {
    func quiet() -> Self
}

internal class Quiet: Parameter {
    var command: String = "--quiet"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasQuietParameter {
    public func quiet() -> Self {
        return self.withAddedParameter(Quiet())
    }
}
