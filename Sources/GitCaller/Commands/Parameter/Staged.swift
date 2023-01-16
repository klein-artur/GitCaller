//
//  Staged.swift
//  
//
//  Created by Artur Hellmann on 16.01.23.
//

import Foundation

/// Makes a command able to use the `--staged` parameter.
public protocol HasStagedParameter: Parametrable {
    func staged() -> Self
}

internal class Staged: Parameter {
    var command: String = "--staged"
}

extension HasStagedParameter {
    public func staged() -> Self {
        return self.withAddedParameter(Staged())
    }
}
