//
//  NoColor.swift
//  
//
//  Created by Artur Hellmann on 05.01.23.
//

import Foundation

/// Makes a command able to use the `--no-color` parameter.
public protocol NoColorable: Parametrable {
    func noColor() -> Self
}

internal class NoColor: Parameter {
    var command: String = "--no-color"
}

extension NoColorable {
    public func noColor() -> Self {
        return self.withAddedParameter(NoColor())
    }
}
