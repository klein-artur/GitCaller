//
//  CommandCommit.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

final class CommandCommit: ParametrableCommandSpec,
                           HasAllParameter,
                           HasMessageParameter,
                           HasPathParameter
{
    public var command: String {
        "commit"
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
    var commit: CommandCommit {
        return CommandCommit(preceeding: self)
    }
}
