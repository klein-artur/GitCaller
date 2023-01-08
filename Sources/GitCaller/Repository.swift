//
//  GitCallerBase.swift
//  
//
//  Created by Artur Hellmann on 08.01.23.
//

import Foundation

/// Baseclass for GitCaller. Enables mockability
public protocol Repository {
    
    /// Clones the project behind URL
    func clone(url: String) async throws -> CloneResult
    
    /// Returns the commits
    func getLog(branchName: String) async throws -> LogResult
    
    /// Returns the commits
    func getLog(commitHash: String) async throws -> LogResult
    
    /// Returns the commits
    func getLog() async throws -> LogResult
    
    /// Returns the git status.
    func getStatus() async throws -> StatusResult
    
    /// Returns a branch list.
    func getBranches() async throws -> BranchResult
}
