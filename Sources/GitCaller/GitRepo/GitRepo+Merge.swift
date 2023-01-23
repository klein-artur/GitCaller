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
}
