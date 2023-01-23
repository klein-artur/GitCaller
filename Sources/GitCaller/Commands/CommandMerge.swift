//
//  CommandMerge.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Git command for git merge
public final class CommandMerge: Command, HasBranchnameParameter, HasAbortParameter, HasNoFFParameter, HasMinusMinusParameter
{
    public override var command: String {
        "merge"
    }
}

extension Git {
    public var merge: CommandMerge {
        CommandMerge(preceeding: self)
    }
}
