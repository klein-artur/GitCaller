//
//  File.swift
//  
//
//  Created by Artur Hellmann on 02.02.23.
//

import Foundation

public final class CommandConfig: Command, HasConfigKeyParameter, HasConfigScopeParameter, HasUnsetParameter {
    public override var command: String {
        "config"
    }
}

extension Git {
    public var config: CommandConfig {
        return CommandConfig(preceeding: self)
    }
}
