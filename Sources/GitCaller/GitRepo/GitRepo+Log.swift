//
//  GitRepo+Log.swift
//  
//
//  Created by Artur Hellmann on 14.02.23.
//

import Foundation

extension GitRepo {
    public func getLog(branchNames: [String]) async throws -> LogResult {
        try await Git()
            .log
            .forEach(branchNames, alternator: { command, branchName in
                command.branchName(branchName)
            })
            .pretty(.format(LogResultParser.prettyFormat))
            .topoOrder()
            .finalResult()
    }
    
    public func getLog(commitHash: String) async throws -> LogResult {
        try await Git()
            .log
            .commitHash(commitHash)
            .pretty(.format(LogResultParser.prettyFormat))
            .topoOrder()
            .finalResult()
    }
    
    public func getLog() async throws -> LogResult {
        try await Git()
            .log
            .pretty(.format(LogResultParser.prettyFormat))
            .topoOrder()
            .all()
            .finalResult()
    }
    
    public func show(commitHash: String) async throws -> LogResult {
        try await Git()
            .show
            .commitHash(commitHash)
            .pretty(.format(LogResultParser.prettyFormat))
            .finalResult()
    }
}

