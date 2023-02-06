//
//  File.swift
//  
//
//  Created by Artur Hellmann on 20.01.23.
//

import Foundation

/// Makes a command able to use the `--` parameter.
public protocol HasMinusMinusParameter: Parametrable {
    func minusMinus() -> Self
}

internal class MinusMinus: Parameter {
    var command: String = "--"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasMinusMinusParameter {
    public func minusMinus() -> Self {
        return self.withAddedParameter(MinusMinus())
    }
}
