//
//  CommandInit.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

/// Git command for git init
public final class CommandInit: ParametrableCommandSpec,
                            HasQuietParameter,
                            HasInitialBranchNameParameter
{
    public var command: String {
        "init"
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
    public var initialize: CommandInit {
        CommandInit(preceeding: self)
    }
}
