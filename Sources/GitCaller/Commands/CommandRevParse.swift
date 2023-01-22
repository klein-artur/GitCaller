//
//  CommandRevParse.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Git command for `git rev-parse`
public final class CommandRevParse: Command, HasGitDirParameter, HasPathFormatParameter
{
    public override var command: String {
        "rev-parse"
    }
}

extension Git {
    public var revParse: CommandRevParse {
        return CommandRevParse(preceeding: self)
    }
}
