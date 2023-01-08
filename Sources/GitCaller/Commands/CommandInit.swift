//
//  CommandInit.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Git command for git init
public final class CommandInit: Command,
                            HasQuietParameter,
                            HasInitialBranchNameParameter
{
    public override var command: String {
        "init"
    }
}

extension Git {
    public var initialize: CommandInit {
        CommandInit(preceeding: self)
    }
}
