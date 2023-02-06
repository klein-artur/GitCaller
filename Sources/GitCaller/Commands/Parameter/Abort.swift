//
//  Abort.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation


/// Makes a command able to use the `--abort` parameter.
public protocol HasAbortParameter: Parametrable {
    func abort() -> Self
}

internal class Abort: Parameter {
    var command: String = "--abort"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasAbortParameter {
    public func abort() -> Self {
        return self.withAddedParameter(Abort())
    }
}
