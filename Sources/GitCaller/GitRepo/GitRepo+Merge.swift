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
        let pipe = Pipe()
        async let result: () = Git().mergetool.tool(tool).minusMinus().path(file).ignoreResult(inputPipe: pipe)
        try pipe.putIn(content: "n")
        try await result
        self.needsUpdate()
    }
    
    public func getMergeCommitMessage() async throws -> String {
        var gitPath = try await Git().revParse.pathFormat(.absolute).gitDir().runAsync()
        gitPath = "\(gitPath.trimmingCharacters(in: .whitespacesAndNewlines))/MERGE_MSG"
        let result: String
        do {
            result = try String(contentsOfFile: gitPath)
        } catch {
            result = ""
        }
        return result
    }
    
    public func abortMerge() async throws {
        try await Git().merge.abort().ignoreResult()
        self.needsUpdate()
    }
    
    public func useOurs(path: String) async throws {
        try await use(path: path, theirs: false)
    }
    
    public func continueMerge() async throws {
        try await Git().merge._continue().ignoreResult()
        self.needsUpdate()
    }
    
    public func useTheirs(path: String) async throws {
        try await use(path: path, theirs: true)
    }
    
    private func use(path: String, theirs: Bool) async throws {
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
            try await self.stage(file: path)
            self.needsUpdate()
        } else {
            throw ParseError(type: .issueParsing, rawOutput: "Something went wrong staging the file")
        }
    }
    
    public func rebase(onto branch: String) async throws {
        try await Git().rebase.branchName(branch).ignoreResult()
        self.needsUpdate()
    }
    
    public func continueRebase() async throws {
        try await Git().rebase._continue().ignoreResult()
        self.needsUpdate()
    }
    
    public func abortRebase() async throws {
        try await Git().rebase.abort().ignoreResult()
        self.needsUpdate()
    }
    
    public func getRebaseCommitMessage() async throws -> String {
        var gitPath = try await Git().revParse.pathFormat(.absolute).gitDir().runAsync()
        gitPath = "\(gitPath.trimmingCharacters(in: .whitespacesAndNewlines))/rebase-merge/message"
        let result: String
        do {
            result = try String(contentsOfFile: gitPath)
        } catch {
            result = ""
        }
        return result
    }
    
}
