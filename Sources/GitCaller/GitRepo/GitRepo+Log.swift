//
//  GitRepo+Log.swift
//  
//
//  Created by Artur Hellmann on 14.02.23.
//

import Foundation

extension GitRepo {
    
    private func runGetLog(command: CommandLog) async throws -> LogResult {
        let count = try await command
            .pretty(.format(LogResultParser.counterFormat))
            .runAsync()
            .split(separator: "%", omittingEmptySubsequences: true)
            .count
        
        let parser = LogResultParser(amount: count)
        
        return try parser.parse(
            result: try await command
                .pretty(.format(LogResultParser.parserFormat))
                .topoOrder()
                .runAsync()
        ).get()
    }
    
    public func getLog(branchNames: [String]) async throws -> LogResult {
        try await runGetLog(
            command: Git()
                .log
                .forEach(branchNames, alternator: { command, branchName in
                    command.branchName(branchName)
                })
        )
    }
    
    public func getLog(commitHash: String) async throws -> LogResult {
        try await runGetLog(
            command: Git()
                .log
                .commitHash(commitHash)
        )
    }
    
    public func getLog() async throws -> LogResult {
        try await runGetLog(
            command: Git()
                .log
                .all()
        )
    }
    
    public func show(commitHash: String) async throws -> LogResult {
        try await Git()
            .show
            .commitHash(commitHash)
            .pretty(.format(LogResultParser.parserFormat))
            .finalResult()
    }
}

