//
//  File.swift
//  
//
//  Created by Artur Hellmann on 09.01.23.
//

import Foundation

/// Makes a command able to add a -b parameter.
public protocol HasLowercaseBParameter: ParametrableCommandSpec{
    func b() -> Self
}

internal class LowercaseB: Parameter {
    var command: String
    
    init() {
        self.command = "-b"
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasLowercaseBParameter {
    public func b() -> Self {
        return self.withAddedParameter(LowercaseB())
    }
}
