//
//  LowercaseD.swift
//  
//
//  Created by Artur Hellmann on 10.01.23.
//

import Foundation

/// Makes a command able to add a `-d` parameter.
public protocol HasLowercaseDParameter: Parametrable {
    func d() -> Self
}

internal class LowercaseD: Parameter {
    var command: String
    
    init() {
        self.command = "-d"
    }
}

extension HasLowercaseDParameter {
    public func d() -> Self {
        return self.withAddedParameter(LowercaseD())
    }
}
