//
//  Annotate.swift
//  
//
//  Created by Artur Hellmann on 07.02.23.
//

import Foundation

/// Makes a command able to use the `--annotate` parameter.
public protocol HasAnnotateParameter: ParametrableCommandSpec{
    func annotate() -> Self
}

internal class Annotate: Parameter {
    var command: String = "--annotate"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasAnnotateParameter {
    public func annotate() -> Self {
        return self.withAddedParameter(Annotate())
    }
}
