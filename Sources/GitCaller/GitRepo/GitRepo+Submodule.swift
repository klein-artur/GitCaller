//
//  GitRepo+Submodule.swift
//
//
//  Created by Artur Hellmann on 07.10.23.
//

import Foundation

extension GitRepo {
    public var listOfSubmodules: SubmoduleResult {
        get async throws {
            try await Git()
                .submodule()
                .finalResult()
        }
    }
    
    public func update(submodule path: String) async throws {
        _ = try await Git()
            .submodule()
            .update()
            .initialize()
            .recursive()
            .path(path)
            .runAsync()
        
        self.repositoryUpdated.send()
    }
}
