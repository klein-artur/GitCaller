//
//  GitRepo.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

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
    
    public func revert(unstagedFile path: String) async throws -> RestoreResult {
        let result = try await Git().restore.path(path).finalResult()
        objectWillChange.send()
        return result
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
    
    public func push(force: Bool, createUpstream: Bool = false, remoteName: String? = nil, newName: String? = nil) async throws -> PushResult {
        let pushResult: PushResult
        if let newName = newName, let remoteName = remoteName {
            if createUpstream {
                pushResult = try await Git().push.setUpstream().remoteName(remoteName).branchName(newName).finalResult()
            } else {
                pushResult = try await Git().push.remoteName(remoteName).branchName(newName).finalResult()
            }
        } else if force {
            pushResult = try await Git().push.force().finalResult()
        } else {
            pushResult = try await Git().push.finalResult()
        }
        if pushResult.didChange {
            objectWillChange.send()
        }
        return pushResult
    }
    
    public func newBranchAndCheckout(name: String) async throws -> CheckoutResult {
        let result = try await Git().checkout.b().branchName(name).finalResult()
        objectWillChange.send()
        return result
    }
    
    public func needsUpdate() {
        self.objectWillChange.send()
    }
}
