//
//  CommandReset.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

import Foundation

/// Git command for `git restart`
public final class CommandReset: Command, HasHardParameter, HasBranchnameParameter
{
    public override var command: String {
        "reset"
    }
}

extension Git {
    public var reset: CommandReset {
        return CommandReset(preceeding: self)
    }
}
