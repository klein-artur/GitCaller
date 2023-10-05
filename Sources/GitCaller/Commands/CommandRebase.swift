//
//  CommandRebase.swift
//  
//
//  Created by Artur Hellmann on 11.02.23.
//

import Foundation

/// Git command for `git rebase`
public final class CommandRebase: ParametrableCommandSpec, HasOntoParameter, HasBranchnameParameter, HasContinueParameter, HasAbortParameter
{
    public var command: String {
        "rebase"
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
    public var rebase: CommandRebase {
        return CommandRebase(preceeding: self)
    }
}
