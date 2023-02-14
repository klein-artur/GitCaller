//
//  CommandShow.swift
//  
//
//  Created by Artur Hellmann on 14.02.23.
//

import Foundation

/// Git command for `git show`
public final class CommandShow: Command, HasCommitHashParameter, HasPrettyParameter
{
    public override var command: String {
        "show"
    }
}

extension Git {
    public var show: CommandShow {
        return CommandShow(preceeding: self)
    }
}
