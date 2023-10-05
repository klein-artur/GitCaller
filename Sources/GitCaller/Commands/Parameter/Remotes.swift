//
//  Remotes.swift
//  
//
//  Created by Artur Hellmann on 07.01.23.
//

import Foundation

/// Makes a command able to use the `--remotes` parameter.
public protocol HasRemotesParameter: ParametrableCommandSpec{
    func remotes() -> Self
}

internal class Remotes: Parameter {
    var command: String = "--remotes"
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasRemotesParameter {
    public func remotes() -> Self {
        return self.withAddedParameter(Remotes())
    }
}
