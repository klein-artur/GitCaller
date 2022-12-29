//
//  File.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Git command for git init
final class CommandInit: Command,
                            Quietable,
                            InitialBranchNamable
{
    override var command: String {
        "init"
    }
}

extension Git {
    var initialize: CommandInit {
        CommandInit(preceeding: self)
    }
}
