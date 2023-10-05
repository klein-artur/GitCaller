//
//  CommandShow.swift
//  
//
//  Created by Artur Hellmann on 14.02.23.
//

import Foundation

/// Git command for `git show`
public final class CommandShow: ParametrableCommandSpec, HasCommitHashParameter, HasPrettyParameter
{
    public var command: String {
        "show"
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
    public var show: CommandShow {
        return CommandShow(preceeding: self)
    }
}
