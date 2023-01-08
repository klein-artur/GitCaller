//
//  GitCaller+Base.swift
//  
//
//  Created by Artur Hellmann on 08.01.23.
//

import Foundation

public class GitRepo { }

extension GitRepo: Repository {
    public func clone(url: String) async throws -> CloneResult {
        try await Git().clone(url: url).finalResult()
    }
    
    public func getLog(branchName: String) async throws -> LogResult {
        try await Git()
            .log
            .branchName(branchName)
            .pretty(.format(LogResultParser.prettyFormat))
            .finalResult()
    }
    
    public func getLog(commitHash: String) async throws -> LogResult {
        try await Git()
            .log
            .commitHash(commitHash)
            .pretty(.format(LogResultParser.prettyFormat))
            .finalResult()
    }
    
    public func getLog() async throws -> LogResult {
        try await Git()
            .log
            .pretty(.format(LogResultParser.prettyFormat))
            .finalResult()
    }
    
    public func getStatus() async throws -> StatusResult {
        try await Git().status.finalResult()
    }
    
    public func getBranches() async throws -> BranchResult {
        try await Git().branch.all().finalResult()
    }
    
}

public extension Repository {
    static var standard: Repository {
        GitRepo()
    }
}
