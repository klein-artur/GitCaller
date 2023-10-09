//
//  CommandUpdate.swift
//
//
//  Created by Artur Hellmann on 09.10.23.
//

import Foundation

/// Git command for `update` for example `git submodule update`.
public final class CommandUpdate: ParametrableCommandSpec, HasInitParameter, HasRecursiveParameter, HasPathParameter {
    public var command: String {
        "update"
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

extension CommandSubmodule {
    public func update() -> CommandUpdate {
        return CommandUpdate(preceeding: self)
    }
}
