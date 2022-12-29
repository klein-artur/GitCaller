//
//  CommandCommit.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

final class CommandCommit: Command,
                           Allable,
                           Messageable,
                           Pathable
{
    override var command: String {
        "commit"
    }
}

extension Git {
    var commit: CommandCommit {
        return CommandCommit(preceeding: self)
    }
}
