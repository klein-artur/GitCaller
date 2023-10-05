//
//  CommandPull.swift
//  
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation

/// Git command for `git pull`
public final class CommandPull: ParametrableCommandSpec, HasForceParameter
{
    public var command: String {
        "pull"
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
    public var pull: CommandPull {
        return CommandPull(preceeding: self)
    }
}
