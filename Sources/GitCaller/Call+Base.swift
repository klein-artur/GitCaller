//
//  GitCaller+Base.swift
//  
//
//  Created by Artur Hellmann on 08.01.23.
//

import Foundation
import Combine

/// Baseclass for GitCaller. Enables mockability
public protocol Repository {
    
    var repositoryUpdated: PassthroughSubject<Void, Never> { get }
    
    /// Clones the project behind URL
    func clone(url: String) async throws -> CloneResult
    
    /// Returns the commits
    func getLog(branchNames: [String]) async throws -> LogResult
    
    /// Returns the commits
    func getLog(commitHash: String) async throws -> LogResult
    
    /// Returns the commits
    func getLog() async throws -> LogResult
    
    /// Returns a log just containing this commit
    func show(commitHash: String) async throws -> LogResult
    
    /// Returns the git status.
    func getStatus() async throws -> StatusResult
    
    /// Returns a branch list.
    func getBranches() async throws -> BranchResult
    
    /// Checks out the given branch.
    func checkout(branch: Branch) async throws -> CheckoutResult
    
    /// Deletes the given branch.
    func delete(branch: Branch, force: Bool) async throws -> BranchResult
    
    /// Adds a given file, if no path given adds all.
    func stage(file path: String?, hunk number: Int?, lines: [Int]?) async throws
    
    /// Adds the given files
    func stage(files paths: [String]) async throws
    
    /// unstages a given file, if no path given adds all.
    func unstage(file path: String?, hunk number: Int?, lines: [Int]?) async throws
    
    /// Unstages the given files
    func unstage(files paths: [String]) async throws
    
    /// reverts unstaged files.
    func revert(unstagedFile path: String) async throws -> RestoreResult
    
    /// reverts unstaged files.
    func revert(unstagedFiles paths: [String]) async throws
    
    /// reverts unstaged files.
    func revertDeleted(unstagedFile path: String) async throws
    
    /// Commits the currently staged files with the given message.
    func commit(message: String) async throws
    
    /// Fetches from origin or the current brachs upstream repo.
    func fetch() async throws
    
    /// Pulls the current branch.
    ///  - force: `true` if the pull should be forced.
    func pull(force: Bool) async throws -> PullResult
    
    /// Pushes the current branch.
    ///  - force: `true` if the pull should be forced.
    func push(force: Bool, createUpstream: Bool, remoteName: String?, newName: String?) async throws -> PushResult
    
    /// Creates a new branch and checks it out.
    func newBranchAndCheckout(name: String) async throws -> CheckoutResult
    
    /// Returns the diff. If a path is given it returns the diff only for the file, if a right path is given the two files will be compared.
    func diff(path: String?, staged: Bool, rightPath: String?) async throws -> DiffResult
    
    /// Informs all listeners that this repo needs an update.
    func needsUpdate()
    
    /// Starts a merge of the branch into the current one.
    func merge(branch: String, noFF: Bool) async throws
    
    /// Uses either theirs or ours in a merge or rebase context.
    func useOurs(path: String) async throws
    func useTheirs(path: String) async throws
    
    /// Aborts the current running merge
    func abortMerge() async throws
    
    /// Continue the current running merge
    func continueMerge() async throws
    
    /// Opens the mergetool on a merge conflict.
    func mergetool(file: String, tool: String) async throws
    
    /// Returns the commit message for a merge if set.
    func getMergeCommitMessage() async throws -> String
    
    /// Gets the config for the given key in the given scope.
    func getConfig(scope: ConfigScope, key: ConfigKey) async throws -> String
    
    /// Sets the config for the given key in the given scope.
    func setConfig(scope: ConfigScope, key: ConfigKey, value: String) async throws
    
    /// Resets the config for the given key in the given scope.
    func unsetConfig(scope: ConfigScope, key: ConfigKey) async throws
    
    /// Creates a tag on the given commit hash. If a message is given, the message is also set.
    func createTag(name: String, on commit: String, message: String?) async throws
    
    /// Pushes the tags.
    func pushTags() async throws
    
    /// Deletes the given tag.
    func deleteTag(name: String) async throws
    
    /// Starts a rebase of the branch into the current one.
    func rebase(onto branch: String) async throws
    
    /// Aborts the current running rebase
    func abortRebase() async throws
    
    /// Continue the current running rebase
    func continueRebase() async throws
    
    /// Returns the commit message for a rebase if set.
    func getRebaseCommitMessage() async throws -> String
    
    // MARK: Submodule
    var listOfSubmodules: SubmoduleResult { get async throws }
}

public extension Repository {
    func push(force: Bool, createUpstream: Bool = false, remoteName: String? = nil, newName: String? = nil) async throws -> PushResult {
        return try await push(force: force, createUpstream: createUpstream, remoteName: remoteName, newName: newName)
    }
    
    func diff(path: String?, staged: Bool = false, rightPath: String? = nil) async throws -> DiffResult {
        return try await diff(path: path, rightPath: rightPath)
    }
    
    func stage(file path: String?, hunk number: Int? = nil, lines: [Int]? = nil) async throws {
        return try await stage(file: path, hunk: number, lines: lines)
    }
    
    func unstage(file path: String?, hunk number: Int? = nil, lines: [Int]? = nil) async throws  {
        return try await unstage(file: path, hunk: number, lines: lines)
    }
    
    func merge(branch: String, noFF: Bool = false) async throws {
        return try await merge(branch: branch, noFF: noFF)
    }
    
    func mergetool(file: String, tool: String = "opendiff") async throws {
        return try await mergetool(file: file, tool: tool)
    }
    
    func createTag(name: String, on commit: String, message: String? = nil) async throws {
        return try await createTag(name: name, on: commit, message: message)
    }
}
