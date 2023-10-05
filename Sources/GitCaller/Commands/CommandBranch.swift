//
//  CommandBranch.swift
//  
//
//  Created by Artur Hellmann on 07.01.23.
//

import Foundation

/// Git command for `git branch`
public final class CommandBranch: ParametrableCommandSpec, HasAllParameter, HasRemotesParameter, HasVerboseParameter, HasLowercaseDParameter, HasUppercaseDParameter, HasBranchnameParameter
{
    public var command: String {
        "branch"
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
    public var branch: CommandBranch {
        return CommandBranch(preceeding: self)
    }
}
