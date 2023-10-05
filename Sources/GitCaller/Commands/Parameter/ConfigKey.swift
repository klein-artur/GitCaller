//
//  ConfigKey.swift
//  
//
//  Created by Artur Hellmann on 02.02.23.
//

import Foundation

public enum ConfigKey: String {
    case coreEditor = "core.editor"
}

/// Makes a command able to use the config key parameter.
public protocol HasConfigKeyParameter: ParametrableCommandSpec{
    func configKey(_ key: ConfigKey, value: String?) -> Self
}

internal class ConfigKeyParameter: Parameter {
    let key: ConfigKey
    let value: String?
    
    init(key: ConfigKey, value: String?) {
        self.key = key
        self.value = value
    }
    
    var command: String {
        if let value = value {
            return "\(key.rawValue) \(value)"
        }
        return "\(key.rawValue)"
    }
    
    func getCommand(forString: Bool) -> String {
        return command
    }
}

extension HasConfigKeyParameter {
    public func configKey(_ key: ConfigKey, value: String? = nil) -> Self {
        return self.withAddedParameter(ConfigKeyParameter(key: key, value: value))
    }
}
