//
//  File.swift
//  
//
//  Created by Artur Hellmann on 02.02.23.
//

import Foundation

public final class CommandConfig: ParametrableCommandSpec, HasConfigKeyParameter, HasConfigScopeParameter, HasUnsetParameter {
    public var command: String {
        "config"
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
    public var config: CommandConfig {
        return CommandConfig(preceeding: self)
    }
}
