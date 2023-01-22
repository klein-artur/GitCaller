//
//  GitRepo+Merge.swift
//  
//
//  Created by Artur Hellmann on 22.01.23.
//

import Foundation

extension GitRepo {
    public func merge(branch: String) async throws {
        try await Git().merge.branchName(branch).ignoreResult()
        self.needsUpdate()
    }
    
    public func mergetool(file: String, tool: String) async throws {
        try await Git().mergetool.tool(tool).minusMinus().path(file).ignoreResult(predefinedInput: "n\n")
        self.needsUpdate()
    }
    
    public func getMergeCommitMessage() async throws -> String {
        var gitPath = try await Git().revParse.gitDir().runAsync()
        gitPath += "/MERGE_MSG"
        return try String(contentsOfFile: gitPath)
    }
}
