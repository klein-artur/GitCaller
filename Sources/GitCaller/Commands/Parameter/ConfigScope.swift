//
//  ConfigScope.swift
//  
//
//  Created by Artur Hellmann on 02.02.23.
//

import Foundation

public enum ConfigScope: String {
    case system = "--system"
    case global = "--global"
    case local = "--local"
}

/// Makes a command able to use the config key parameter.
public protocol HasConfigScopeParameter: Parametrable {
    func configScope(_ value: ConfigScope) -> Self
}

internal class ConfigScopeParameter: Parameter {
    let value: ConfigScope
    
    init(value: ConfigScope) {
        self.value = value
    }
    
    var command: String {
        "\(value.rawValue)"
    }
}

extension HasConfigScopeParameter {
    public func configScope(_ value: ConfigScope) -> Self {
        return self.withAddedParameter(ConfigScopeParameter(value: value))
    }
}
