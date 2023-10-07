//
//  Submodule.swift
//
//
//  Created by Artur Hellmann on 05.10.23.
//

import Foundation

/// Git command for `git submodule`.
public final class CommandSubmodule: ParametrableCommandSpec {
    public var command: String {
        "submodule"
    }
    
    public var parameter: [Parameter]
    
    public var preceeding: (any CommandSpec)?
    
    public init(
        preceeding: (any CommandSpec)?,
        parameter: [Parameter] = []
    ) {
        self.preceeding = preceeding
        self.parameter = parameter
    }
}

extension Git {
    public func submodule() -> CommandSubmodule {
        return CommandSubmodule(preceeding: self)
    }
}
