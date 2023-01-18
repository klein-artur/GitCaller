//
//  CommandPull.swift
//  
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation

/// Git command for `git pull`
public final class CommandPull: Command, HasForceParameter
{
    public override var command: String {
        "pull"
    }
}

extension Git {
    public var pull: CommandPull {
        return CommandPull(preceeding: self)
    }
}
