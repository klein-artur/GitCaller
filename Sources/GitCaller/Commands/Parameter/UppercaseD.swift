//
//  File.swift
//  
//
//  Created by Artur Hellmann on 10.01.23.
//

import Foundation

/// Makes a command able to add a `-D` parameter.
public protocol HasUppercaseDParameter: Parametrable {
    func D() -> Self
}

internal class UppercaseD: Parameter {
    var command: String
    
    init() {
        self.command = "-D"
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasUppercaseDParameter {
    public func D() -> Self {
        return self.withAddedParameter(UppercaseD())
    }
}
