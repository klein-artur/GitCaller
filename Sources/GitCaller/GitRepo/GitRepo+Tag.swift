//
//  GitRepo+Tag.swift
//  
//
//  Created by Artur Hellmann on 07.02.23.
//

import Foundation

extension GitRepo {
    public func createTag(name: String, on commit: String, message: String? = nil) async throws {
        try await Git()
            .tag
            .tagName(name)
            .commitHash(commit)
            .conditionalLet(message, alternator: { command, message in
                command.message(message)
            })
            .ignoreResult()
        needsUpdate()
    }
    
    public func deleteTag(name: String) async throws {
        try await Git()
            .tag
            .d()
            .tagName(name)
            .ignoreResult()
        needsUpdate()
    }
    
    public func pushTags() async throws {
        try await Git()
            .push
            .tags()
            .ignoreResult()
        needsUpdate()
    }
}
