//
//  CommandLog.swift
//  
//
//  Created by Artur Hellmann on 02.01.23.
//

import Foundation

/// Git command for `git log`
public final class CommandLog: Command, CommitHashable, BranchNamable
{
    public override var command: String {
        "log"
    }
}

extension Git {
    public var log: CommandLog {
        return CommandLog(preceeding: self)
    }
}
