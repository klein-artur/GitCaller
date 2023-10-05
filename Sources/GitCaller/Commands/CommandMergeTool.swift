//
//  CommandMergeTool.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Git command for git mergetool
public final class CommandMergeTool: ParametrableCommandSpec, HasPathParameter, HasToolParameter, HasMinusMinusParameter {
    public var command: String {
        "mergetool"
    }
    
    public var parameter: [Parameter]
    
    public var preceeding: (any CommandSpec)?
    
    public init(
        preceeding: (any CommandSpec)?,
        parameter: [Parameter] = []
    ) {
        self.preceeding = preceeding
        self.parameter = parameter
    }
}

extension Git {
    public var mergetool: CommandMergeTool {
        CommandMergeTool(preceeding: self)
    }
}
