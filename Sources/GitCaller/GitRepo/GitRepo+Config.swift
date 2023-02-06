//
//  GitRepo+Config.swift
//  
//
//  Created by Artur Hellmann on 02.02.23.
//

import Foundation

extension GitRepo {
    
    public func getConfig(scope: ConfigScope, key: ConfigKey) async throws -> String {
        return try await Git().config.configScope(scope).configKey(key).runAsync()
    }
    
    public func setConfig(scope: ConfigScope, key: ConfigKey, value: String) async throws {
        _ = try await Git().config.configScope(scope).configKey(key).runAsync()
    }
    
    public func unsetConfig(scope: ConfigScope, key: ConfigKey) async throws {
        _ = try await Git().config.configScope(scope).unset().configKey(key).runAsync()
    }
    
}
