//
//  StatusParser.swift
//  
//
//  Created by Artur Hellmann on 30.12.22.
//

import Foundation
import Combine

/// Representing a `git status` command result
public struct StatusResult: ParseResult {
    
    public var originalOutput: String
    
    public let branch: Branch
    
    public let isMerging: Bool
    public let isRebasing: Bool
    
    public let rebasingStepsDone: Int
    public let rebasingStepsRemaining: Int
    
    public var stagedChanges: [Change] = []
    public var unstagedChanges: [Change] = []
    public var untrackedChanges: [Change] = []
    public var unmergedChanges: [Change] = []
    
    public var numberObRebaseSteps: Int {
        rebasingStepsRemaining + rebasingStepsDone
    }
    
    public var status: Status {
        
        if isMerging {
            return .merging
        }
        
        if isRebasing {
            return .rebasing
        }
        
        if !stagedChanges.isEmpty || !unstagedChanges.isEmpty || !untrackedChanges.isEmpty {
            return .unclean
        }
        
        return .clean
    }
    
    /// A combined list of unstaged, unmerged and untracked changes.
    public var combinedUnstagedChanges: [Change] {
        unstagedChanges + unmergedChanges + untrackedChanges
    }
    
    /// A status the git repo can have.
    public enum Status {
        
        /// Repo is clean and ready to go.
        case clean
        
        /// Repo has changes.
        case unclean
        
        /// Repo is in merging state
        case merging
        
        /// Repo is currently in a rebase state
        case rebasing
    }
}

public struct Change {
    public let path: String
    public let kind: Kind
    public let state: State
    public let additionals: String
    
    public enum Kind: String {
        case modified = "modified"
        case deleted = "deleted"
        case newFile = "new file"
        case bothAdded = "both added"
        case bothModified = "both modified"
        case renamed = "renamed"
        case deletedByUs = "deleted by us"
        case deletedByThem = "deleted by them"
    }
    
    public enum State {
        case staged
        case unstaged
        case untracked
        case unmerged
    }
}

public class StatusParser: GitParser, Parser {
    
    public typealias Success = StatusResult
    
    override public init() {
        super.init()
    }
    
    public func parse(result: String) -> Result<Success, ParseError> {
        if let error = super.parseForIssues(result: result) {
            return .failure(error)
        }
        
        let branchResult = result.find(rgx: "On branch (.*)|(?:You are currently rebasing branch|You are currently editing a commit while rebasing branch) '(.*)' on").first
        var branchName = branchResult?[1] ?? branchResult?[2]
        var detached = false
        
        if let head = result.find(rgx: "(HEAD) detached").first?[1] {
            branchName = head
            detached = true
        }
        
        var isRebasing = false
        if result.find(rgx: #"You are currently rebasing branch |You are currently editing a commit while rebasing branch "#).first != nil {
            isRebasing = true
        }
        
        var doneRebasingSteps = 0
        if let doneResult = result.find(rgx: #"Last commands? done \(([0-9]+) commands? done\)"#).first {
            doneRebasingSteps = Int(doneResult[1] ?? "0") ?? 0
        }
        
        var remainingRebasingSteps = 0
        if let doneResult = result.find(rgx: #"Next commands? to do \(([0-9]+) remaining commands?\)"#).first {
            remainingRebasingSteps = Int(doneResult[1] ?? "0") ?? 0
        }
        
        guard let branchName = branchName else {
            return .failure(ParseError(type: .noBranchNameFound, rawOutput: result))
        }
        
        var behind = 0
        var ahead = 0
        
        if let isBehind = Int(result.find(rgx: "behind '.*' by ([0-9]+) commit").first?[1] ?? "0") {
            behind = isBehind
        }
        
        if let isAhead = Int(result.find(rgx: "ahead of '.*' by ([0-9]+) commit").first?[1] ?? "0") {
            ahead = isAhead
        }
        
        if let divergedResult = result.find(rgx: "and have ([0-9]+) and ([0-9]+) different").first, let foundAhead = divergedResult[1], let foundBehind = divergedResult[2] {
            ahead = Int(foundAhead) ?? 0
            behind = Int(foundBehind) ?? 0
        }
        
        var isMerging = false
        if result.find(rgx: #"\nAll conflicts fixed but you are still merging\.\n|\nYou have unmerged paths\.\n"#).first != nil {
            isMerging = true
        }
        
        var upstream: Branch?
        if let upstreamName = result.find(rgx: "(?:with|behind|and|of) '(.*)'").first?[1] {
            upstream = Branch(name: upstreamName, isCurrent: false, isLocal: false)
        }
        
        return .success(
            StatusResult(
                originalOutput: result,
                branch: Branch(
                    name: branchName,
                    isCurrent: true,
                    isLocal: true,
                    behind: behind,
                    ahead: ahead,
                    upstream: upstream,
                    detached: detached
                ),
                isMerging: isMerging,
                isRebasing: isRebasing,
                rebasingStepsDone: doneRebasingSteps,
                rebasingStepsRemaining: remainingRebasingSteps,
                stagedChanges: getStagedChanged(in: result),
                unstagedChanges: getUnstagedChanges(in: result),
                untrackedChanges: getUntrackedFiles(in: result),
                unmergedChanges: getUnmergedChanges(in: result)
            )
        )
    }
    
    private func getStagedChanged(in result: String) -> [Change] {
        guard let stagedGroup = result.find(rgx: #"Changes to be committed:(?:\n.*)?\n(?:\s*(?:modified|deleted|new file|renamed):\s*.*\n?)+"#).first?[0] else {
            return []
        }
        
        return findChangesIn(group: stagedGroup, state: .staged)
    }
    
    private func getUnstagedChanges(in result: String) -> [Change] {
        guard let unstagedGroup = result.find(rgx: #"Changes not staged for commit:\n.*\n.*\n(?:\s*(?:modified|deleted|new file):\s*.*\n?)+"#).first?[0] else {
            return []
        }
        
        return findChangesIn(group: unstagedGroup, state: .unstaged)
    }
    
    private func getUnmergedChanges(in result: String) -> [Change] {
        guard let unmergedGroup = result.find(rgx: #"Unmerged paths:(?:\n.*)+\n(?:\s*(?:both added|both modified|deleted by them|deleted by us):\s*.*\n?)+"#).first?[0] else {
            return []
        }
        
        return findChangesIn(group: unmergedGroup, state: .unmerged)
    }
    
    private func getUntrackedFiles(in result: String) -> [Change] {
        guard let untrackedGroup = result.find(rgx: #"Untracked files:\n\s+\(use "git add <file>\.\.\." to include in what will be committed\)\n([\s\S]+)"#).first?[1] else {
            return []
        }
        
        return untrackedGroup.find(rgx: #"\s+([^(\n")]+)(?:\n|\Z)"#)
            .map { $0[1]! }
            .filter { !$0.isEmpty }
            .map { foundChange in
                Change(
                    path: foundChange,
                    kind: .newFile,
                    state: .untracked,
                    additionals: ""
                )
            }
    }
    
    private func findChangesIn(group: String, state: Change.State) -> [Change] {
        return group.find(rgx: #"\s*(modified|deleted|new file|both added|both modified|renamed|deleted by them|deleted by us):\s*([^(\n]+)(?:\((.*)\))?"#)
            .map { foundChange in
                let substring = foundChange[2]?.split(separator: " -> ").last
                let path = String(substring!).trimmingCharacters(in: .whitespacesAndNewlines)
                return Change(
                    path: path,
                    kind: Change.Kind(rawValue: foundChange[1]!)!,
                    state: state,
                    additionals: foundChange[3] ?? ""
                )
            }
    }
}

/// Tests
public extension StatusResult {
    static func getTestStatus() -> StatusResult {
        StatusResult(
            originalOutput: "",
            branch: Branch(
                name: "some_very_long/branch_name",
                isCurrent: true,
                isLocal: true,
                behind: 15,
                ahead: 10,
                upstream: Branch(name: "origin/some_very_very_very_very_very_long/branch_name", isCurrent: false, isLocal: false),
                detached: false
            ),
            isMerging: false,
            isRebasing: false,
            rebasingStepsDone: 0,
            rebasingStepsRemaining: 0,
            stagedChanges: [Change(path: "some/path.file", kind: .newFile, state: .staged, additionals: "")],
            unstagedChanges: [Change(path: "some/other/path.file", kind: .newFile, state: .unstaged, additionals: "")],
            untrackedChanges: [Change(path: "some/new/path.file", kind: .newFile, state: .untracked, additionals: "")],
            unmergedChanges: [Change(path: "some/unmerged/path.file", kind: .bothAdded, state: .unmerged, additionals: "")]
        )
    }
}

extension CommandStatus: Parsable {
    
    public typealias Success = StatusResult
    
    public var parser: StatusParser {
        return StatusParser()
    }
}
