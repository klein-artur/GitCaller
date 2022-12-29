//
//  File.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Makes a command able to use the `--all` parameter.
protocol Allable: Parametrable {
    func all() -> Self
}

internal class All: Parameter {
    var command: String = "--all"
}

extension Allable {
    func all() -> Self {
        return self.withAddedParameter(All())
    }
}
