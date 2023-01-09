//
//  File.swift
//  
//
//  Created by Artur Hellmann on 09.01.23.
//

import Foundation

/// Makes a command able to add a -b parameter.
public protocol HasLowercaseBParameter: Parametrable {
    func b() -> Self
}

internal class LowercaseB: Parameter {
    var command: String
    
    init() {
        self.command = "-b"
    }
}

extension HasLowercaseBParameter {
    public func b() -> Self {
        return self.withAddedParameter(LowercaseB())
    }
}
