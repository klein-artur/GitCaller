//
//  LowercaseD.swift
//  
//
//  Created by Artur Hellmann on 10.01.23.
//

import Foundation

/// Makes a command able to add a `-d` parameter.
public protocol HasLowercaseDParameter: ParametrableCommandSpec{
    func d() -> Self
}

internal class LowercaseD: Parameter {
    var command: String
    
    init() {
        self.command = "-d"
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasLowercaseDParameter {
    public func d() -> Self {
        return self.withAddedParameter(LowercaseD())
    }
}
