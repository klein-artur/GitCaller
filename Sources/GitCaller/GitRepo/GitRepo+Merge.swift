//
//  GitRepo+Merge.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

extension GitRepo {
    public func merge(branch: String, noFF: Bool) async throws {
        try await Git()
            .merge
            .conditional(noFF, alternator: { command in
                command.noFF()
            })
            .minusMinus()
            .branchName(branch)
            .ignoreResult()
        self.needsUpdate()
    }
    
    public func mergetool(file: String, tool: String) async throws {
        try await Git().mergetool.tool(tool).minusMinus().path(file).ignoreResult(predefinedInput: "n\n")
        self.needsUpdate()
    }
    
    public func getMergeCommitMessage() async throws -> String {
        var gitPath = try await Git().revParse.pathFormat(.absolute).gitDir().runAsync()
        gitPath = "\(gitPath.trimmingCharacters(in: .whitespacesAndNewlines))/MERGE_MSG"
        return try String(contentsOfFile: gitPath)
    }
    
    public func abortMerge() async throws {
        try await Git().merge.abort().ignoreResult()
        self.needsUpdate()
    }
    
    public func useOurs(path: String) async throws -> CheckoutResult {
        try await use(path: path, theirs: false)
    }
    
    public func useTheirs(path: String) async throws -> CheckoutResult {
        try await use(path: path, theirs: true)
    }
    
    private func use(path: String, theirs: Bool) async throws -> CheckoutResult {
        let result = try await Git().checkout
            .conditional(theirs) { command in
                command.theirs()
            }
            .conditional(!theirs) { command in
                command.ours()
            }
            .path(path)
            .finalResult()
        if result.didChange {
            objectWillChange.send()
        }
        return result
    }
}
