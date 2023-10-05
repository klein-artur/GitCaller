//
//  CommandRestore.swift
//
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public final class CommandRestore: ParametrableCommandSpec, HasPathParameter, HasStagedParameter, HasMinusMinusParameter, HasPatchParameter {
    public var command: String {
        "restore"
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
    public var restore: CommandRestore {
        return CommandRestore(preceeding: self)
    }
}
