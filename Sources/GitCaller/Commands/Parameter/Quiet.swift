//
//  File.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to use the `--quiet` parameter.
public protocol Quietable: Parametrable {
    func quiet() -> Self
}

internal class Quiet: Parameter {
    var command: String = "--quiet"
}

extension Quietable {
    public func quiet() -> Self {
        return self.withAddedParameter(Quiet())
    }
}
