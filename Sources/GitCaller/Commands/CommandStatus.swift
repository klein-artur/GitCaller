//
//  CommandStatus.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public final class CommandStatus: ParametrableCommandSpec
{
    public var command: String {
        "status"
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
    public var status: CommandStatus {
        return CommandStatus(preceeding: self)
    }
}
