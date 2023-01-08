//
//  Remotes.swift
//  
//
//  Created by Artur Hellmann on 07.01.23.
//

import Foundation

/// Makes a command able to use the `--remotes` parameter.
public protocol HasRemotesParameter: Parametrable {
    func remotes() -> Self
}

internal class Remotes: Parameter {
    var command: String = "--remotes"
}

extension HasRemotesParameter {
    public func remotes() -> Self {
        return self.withAddedParameter(Remotes())
    }
}
