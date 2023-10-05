//
//  CommandFetch.swift
//  
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation

public final class CommandFetch: ParametrableCommandSpec, HasAllParameter {
    public var command: String {
        "fetch"
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
    public var fetch: CommandFetch {
        return CommandFetch(preceeding: self)
    }
}
