//
//  Hard.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

import Foundation

/// Makes a command able to use the `--hard` parameter.
public protocol HasHardParameter: Parametrable {
    func hard() -> Self
}

internal class Hard: Parameter {
    var command: String = "--hard"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasHardParameter {
    public func hard() -> Self {
        return self.withAddedParameter(Hard())
    }
}
