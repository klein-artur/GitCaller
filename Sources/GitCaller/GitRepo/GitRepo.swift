//
//  GitRepo.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation
import Combine

public class GitRepo {
    
    private var internalCancellables: [AnyCancellable] = []
    
    private var lastState: StatusResult? = nil
    
    private var ignoreNextElement = false
    
    init() {
        Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .flatMap { date in
                Git().status.run()
                    .last()
            }
            .removeDuplicates()
            .filter({ [weak self] _ in
                let ignore = self?.ignoreNextElement ?? false
                self?.ignoreNextElement = false
                return !ignore
            })
            .sink { [weak self]_ in
                self?.objectWillChange.send()
            }
            .store(in: &internalCancellables)
    }
    
    public func needsUpdate() {
        self.ignoreNextElement = true
        self.objectWillChange.send()
    }
}

extension GitRepo: Repository {
    
    public static let standard: GitRepo = GitRepo()
    
    public func clone(url: String) async throws -> CloneResult {
        try await Git().clone(url: url).finalResult()
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
            needsUpdate()
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
        needsUpdate()
        return result
    }
    
    public func revert(unstagedFile path: String) async throws -> RestoreResult {
        let result = try await Git().restore.path(path).finalResult()
        needsUpdate()
        return result
    }
    
    public func revert(unstagedFiles paths: [String]) async throws {
        if paths.isEmpty {
            try await Git()
                .reset
                .hard()
                .ignoreResult()
        } else {
            try await Git()
                .restore
                .minusMinus()
                .forEach(paths, alternator: { command, path in
                    command.path(path)
                })
                .ignoreResult()
        }
        needsUpdate()
    }
    
    public func revertDeleted(unstagedFile path: String) async throws {
        try await Git().checkout.branchName("HEAD").path(path).ignoreResult()
        needsUpdate()
    }
    
    public func fetch() async throws {
        try await Git().fetch.ignoreResult()
        needsUpdate()
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
            needsUpdate()
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
            needsUpdate()
        }
        return pushResult
    }
    
    public func newBranchAndCheckout(name: String) async throws -> CheckoutResult {
        let result = try await Git().checkout.b().branchName(name).finalResult()
        needsUpdate()
        return result
    }
}
