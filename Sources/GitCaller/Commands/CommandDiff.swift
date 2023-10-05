//
//  CommandDiff.swift
//  
//
//  Created by Artur Hellmann on 20.01.23.
//

import Foundation

public final class CommandDiff: ParametrableCommandSpec, HasPathParameter, HasStagedParameter, HasMinusMinusParameter {
    
    public var command: String {
        "diff"
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
    public var diff: CommandDiff {
        return CommandDiff(preceeding: self)
    }
}
