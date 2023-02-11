//
//  CommandRebase.swift
//  
//
//  Created by Artur Hellmann on 11.02.23.
//

import Foundation

/// Git command for `git rebase`
public final class CommandRebase: Command, HasOntoParameter, HasBranchnameParameter, HasContinueParameter, HasAbortParameter
{
    public override var command: String {
        "rebase"
    }
}

extension Git {
    public var rebase: CommandRebase {
        return CommandRebase(preceeding: self)
    }
}
