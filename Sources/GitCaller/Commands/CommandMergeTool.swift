//
//  CommandMergeTool.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Git command for git mergetool
public final class CommandMergeTool: Command, HasPathParameter, HasToolParameter, HasMinusMinusParameter {
    public override var command: String {
        "mergetool"
    }
}

extension Git {
    public var mergetool: CommandMergeTool {
        CommandMergeTool(preceeding: self)
    }
}
