//
//  CommandPush.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

import Foundation

/// Git command for `git push`
public final class CommandPush: Command, HasForceParameter
{
    public override var command: String {
        "push"
    }
}

extension Git {
    public var push: CommandPush {
        return CommandPush(preceeding: self)
    }
}
