//
//  GitCaller+Base.swift
//  
//
//  Created by Artur Hellmann on 08.01.23.
//

import Foundation
import SwiftUI

public class GitRepo { }

extension GitRepo: Repository {
    
    public static let standard: GitRepo = GitRepo()
    
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
        try await Git().branch.all().verbose().verbose().finalResult()
    }
    
    public func checkout(branch: Branch) async throws -> CheckoutResult {
        let result: CheckoutResult
        if branch.isLocal {
            result = try await Git().checkout.branchName(branch.name).finalResult()
        } else {
            result = try await Git().checkout.track().branchName(branch.name).finalResult()
        }
        if result.didChange {
            objectWillChange.send()
        }
        return result
    }
    
    public func delete(branch: Branch, force: Bool = false) async throws -> BranchResult {
        let result: BranchResult
        if branch.isLocal {
            var command = Git().branch.branchName(branch.name)
            if force {
                command = command.D()
            } else {
                command = command.d()
            }
            result = try await command.finalResult()
        } else {
            
            // TODO: Delete remotes.
            result = try await Git().branch.finalResult()
        }
        objectWillChange.send()
        return result
    }
    
    public func stage(file path: String?) async throws {
        if let path = path {
            try await Git().add.path(path).ignoreResult()
        } else {
            try await Git().add.all().ignoreResult()
        }
        objectWillChange.send()
    }
    
    public func unstage(file path: String) async throws -> RestoreResult {
        let result =  try await Git().restore.staged().path(path).finalResult()
        objectWillChange.send()
        return result
    }
    
    public func revert(unstagedFile path: String) async throws -> RestoreResult {
        let result = try await Git().restore.path(path).finalResult()
        objectWillChange.send()
        return result
    }
    
    public func commit(message: String) async throws {
        try await Git().commit.message(message).ignoreResult()
        objectWillChange.send()
    }
    
    public func fetch() async throws {
        try await Git().fetch.ignoreResult()
        objectWillChange.send()
    }
    
    public func pull(force: Bool) async throws -> PullResult {
        let pullResult: PullResult
        if force {
//            try await Git().fetch.ignoreResult()
//            do {
//                let result = try await Git().reset.hard().branchName("HEAD").runAsync()
//                print(result)
//            } catch {
//                throw ParseError(type: .issueParsing, rawOutput: "")
//            }
            pullResult = try await Git().pull.force().finalResult()
        } else {
            pullResult = try await Git().pull.finalResult()
        }
        if pullResult.didChange {
            objectWillChange.send()
        }
        return pullResult
    }
    
    public func push(force: Bool) async throws -> PushResult {
        let pushResult: PushResult
        if force {
            pushResult = try await Git().push.force().finalResult()
        } else {
            pushResult = try await Git().push.finalResult()
        }
        if pushResult.didChange {
            objectWillChange.send()
        }
        return pushResult
    }

}

/// Baseclass for GitCaller. Enables mockability
public protocol Repository: ObservableObject {
    
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
    
    /// Checks out the given branch.
    func checkout(branch: Branch) async throws -> CheckoutResult
    
    /// Deletes the given branch.
    func delete(branch: Branch, force: Bool) async throws -> BranchResult
    
    /// Adds a given file, if no path given adds all.
    func stage(file path: String?) async throws
    
    /// unstages a given file, if no path given adds all.
    func unstage(file path: String) async throws -> RestoreResult
    
    /// reverts unstaged files.
    func revert(unstagedFile path: String) async throws -> RestoreResult
    
    /// Commits the currently staged files with the given message.
    func commit(message: String) async throws
    
    /// Fetches from origin or the current brachs upstream repo.
    func fetch() async throws
    
    /// Pulls the current branch.
    ///  - force: `true` if the pull should be forced.
    func pull(force: Bool) async throws -> PullResult
    
    /// Pushes the current branch.
    ///  - force: `true` if the pull should be forced.
    func push(force: Bool) async throws -> PushResult
}
