//
//  CommandRevParse.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

/// Git command for `git rev-parse`
public final class CommandRevParse: ParametrableCommandSpec, HasGitDirParameter, HasPathFormatParameter
{
    public var command: String {
        "rev-parse"
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
    public var revParse: CommandRevParse {
        return CommandRevParse(preceeding: self)
    }
}
