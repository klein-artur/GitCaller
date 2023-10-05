//
//  CommandReset.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

import Foundation

/// Git command for `git restart`
public final class CommandReset: ParametrableCommandSpec, HasHardParameter, HasBranchnameParameter
{
    public var command: String {
        "reset"
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
    public var reset: CommandReset {
        return CommandReset(preceeding: self)
    }
}
