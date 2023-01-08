//
//  CommandBranch.swift
//  
//
//  Created by Artur Hellmann on 07.01.23.
//

import Foundation

/// Git command for `git branch`
public final class CommandBranch: Command, HasAllParameter, HasRemotesParameter
{
    
    public override var command: String {
        "branch"
    }
}

extension Git {
    public var branch: CommandBranch {
        return CommandBranch(preceeding: self)
    }
}
