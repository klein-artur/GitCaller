//
//  LogParser.swift
//  
//
//  Created by Artur Hellmann on 03.01.23.
//

import Foundation

public class LogResult: ParseResult {
    public var originalOutput: String
    
    public var commits: CommitList?
    
    public var commitPathTree: CommitInfoList? {
        if let commits = commits {
            return CommitInfoList(base: commits)
        } else {
            return nil
        }
    }
    
    public init(
        originalOutput: String,
        commits: CommitList? = nil,
        commitDict: [String : Commit]? = nil
    ) {
        self.originalOutput = originalOutput
        self.commits = commits
    }
}

public class CommitTreeItem {
    public let commit: Commit
    public let branches: [CommitTreeBranch]
    
    public init(branches: [CommitTreeBranch], commit: Commit) {
        self.branches = branches
        self.commit = commit
    }
}

public class CommitTreeBranch {
    public var incoming: [Line]
    public var outgoing: [Line]
    public var hasBubble: Bool
    public var trace: Int
    
    public init(incoming: [Line], outgoing: [Line], hasBubble: Bool, trace: Int) {
        self.incoming = incoming
        self.outgoing = outgoing
        self.hasBubble = hasBubble
        self.trace = trace
    }
}

public struct Line {
    public let begins: Int
    public let ends: Int
    public let isShift: Bool
    
    public init(begins: Int, ends: Int, isShift: Bool) {
        self.begins = begins
        self.ends = ends
        self.isShift = isShift
    }
}

public class CommitListInformation {
    public let commit: Commit
    public let treeItem: CommitTreeItem
    
    public init(commit: Commit, treeItem: CommitTreeItem) {
        self.commit = commit
        self.treeItem = treeItem
    }
}

indirect enum PathStep {
    case opens(from: Int, shiftBy: Int)
    case begins(commit: Commit)
    case commit(commit: Commit)
    case fallThrough(toCommit: Commit?, closes: Int?, opens: Int?, shiftBy: Int)
    case closes(to: Int, shiftBy: Int)
    
    var fallThroughOpens: Int? {
        switch self {
        case .fallThrough(_, _, let opens, _):
            return opens
        default: return nil
        }
    }
    
    var fallThroughShiftBy: Int {
        switch self {
        case .fallThrough(_, _, _, let shiftBy):
            return shiftBy
        default: return 0
        }
    }
    
    var fallThroughNextCommit: Commit? {
        switch self {
        case .fallThrough(let commit, _, _, _):
            return commit
        default: return nil
        }
    }
}

class GitPath {
    var currentStep: PathStep?
    var nextStep: PathStep?
    let trace: Int
    let position: Int
    
    init(currentStep: PathStep?, nextStep: PathStep?, trace: Int, position: Int) {
        self.currentStep = currentStep
        self.nextStep = nextStep
        self.trace = trace
        self.position = position
    }
}

public class CommitList: BidirectionalCollection, RandomAccessCollection {
    
    private static let hunkSize = 10
    
    public typealias Element = Commit
    
    public typealias Index = Int
    
    public typealias SubSequence = CommitList
    
    public typealias Indices = CountableRange<Int>
    
    lazy var amount: Int = {
        parser.amount ?? base.find(rgx: LogResultParser.commitDelimiter).count
    }()
    
    private var commits: [Commit] = []
    
    let base: String
    var rest: String
    let parser: LogResultParser
    
    init(base: String, parser: LogResultParser) {
        self.base = base
        self.parser = parser
        self.rest = base
    }
    
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        amount
    }
    
    public func index(before i: Int) -> Int {
        i - 1
    }
    
    public func index(after i: Int) -> Int {
        i + 1
    }
    
    public subscript(position: Int) -> Element {
        try! self.resolveUntil(index: position)
        return commits[position]
    }
    
    public subscript(bounds: Range<Index>) -> SubSequence {
        return CommitList(base: "", parser: LogResultParser())
    }
    
    private func resolveUntil(index: Int) throws {
        while commits.count < index + 1 && !rest.isEmpty {
            print("resolving hunk for index \(index)")
            let (resolvedCommits, toRemove) = try parser.parse(hunk: rest, number: Self.hunkSize)
            commits.append(contentsOf: resolvedCommits)
            rest.trimPrefix(toRemove)
        }
    }
}

public class CommitInfoList: BidirectionalCollection, RandomAccessCollection {
    
    public enum CommitListError: Error {
        case outOfBounds
    }
    
    public var indices: CountableRange<Int> {
        CountableRange<Int>(uncheckedBounds: (0, endIndex))
    }
    
    public typealias Index = Int
    
    public typealias SubSequence = CommitInfoList
    
    public typealias Indices = CountableRange<Int>
    
    public typealias Element = CommitListInformation
    
    let base: CommitList
    var commitDictSafe: [String: Commit] = [:]
    var indexedObjects = [Element]()
    var foundParents: Set<String> = Set()
    var accessedIndex = 0
    
    var paths = [GitPath]()
    
    var currentTreeCommits: [Commit]
    private var currentTrace = 0
    
    public func index(before i: Int) -> Int {
        i - 1
    }
    
    public func index(after i: Int) -> Int {
        i + 1
    }
    
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        return base.count
    }
    
    init(base: CommitList) {
        self.base = base
        let firstCommit = base.first
        self.currentTreeCommits = firstCommit != nil ? [firstCommit!] : []
    }
    
    private func getCommitByHash(hash: String) -> Commit? {
        if let commit = commitDictSafe[hash] {
            return commit
        }
        guard let commit = base.first (where: { $0.objectHash == hash }) else {
            return nil
        }
        commitDictSafe[hash] = commit
        return commit
    }
    
    public subscript(position: Index) -> Element {
        print("subscript of position: \(position)")
        if position >= indexedObjects.count {
            (indexedObjects.count...position).forEach {
                let commit = commit(for: position)
                indexedObjects.append(
                    CommitListInformation(
                        commit: commit,
                        treeItem: getCommitTreeItem(for: $0)
                    )
                )
            }
        }

        return indexedObjects[position]
    }
    
    public subscript(bounds: Range<Index>) -> SubSequence {
        return CommitInfoList(base: CommitList(base: "", parser: LogResultParser()))
    }
    
    public subscript(hash: String) -> Element? {
        return self.first { commitInfo in
            commitInfo.commit.objectHash == hash || commitInfo.commit.shortHash == hash
        }
    }
    
    private func commit(for position: Index) -> Commit {
        return base[position]
    }
    
    private func getCommitTreeItem(for position: Int) -> CommitTreeItem {
        let currentCommit = commit(for: position)
        
        var treeBranches = [CommitTreeBranch]()
        
        let paths = getPaths(for: position)
        
        for (index, path) in paths.enumerated() {
            switch path.currentStep {
            case .opens(let from, let shiftBy):
                treeBranches.append(
                    CommitTreeBranch(incoming: [], outgoing: [Line(begins: from, ends: index - shiftBy, isShift: false)], hasBubble: false, trace: path.trace)
                )
            case .closes(let to, let shiftBy):
                treeBranches.append(
                    CommitTreeBranch(incoming: [Line(begins: index, ends: to - shiftBy, isShift: false)], outgoing: [], hasBubble: false, trace: path.trace)
                )
            case .commit(_), .begins(_):
                var incoming = [Line]()
                
                if case .commit = path.currentStep, position != 0 {
                    incoming = [Line(begins: index, ends: index, isShift: false)]
                }
                
                var outgoing = [Line]()
                
                if position < self.count - 1 {
                    outgoing = [Line(begins: index, ends: index, isShift: false)]
                }
                
                treeBranches.append(
                    CommitTreeBranch(incoming: incoming, outgoing: outgoing, hasBubble: true, trace: path.trace)
                )
            case .fallThrough(_, _, let opens, let shiftBy):
                let income = [Line(begins: index, ends: index, isShift: false)]
                
                var outgoing = [Line(begins: index, ends: index - shiftBy, isShift: shiftBy != 0)]
                
                if let opens = opens {
                    outgoing.append(Line(begins: opens, ends: index, isShift: true))
                }
                
                treeBranches.append(
                    CommitTreeBranch(incoming: income, outgoing: outgoing, hasBubble: false, trace: path.trace)
                )
            default: break
            }
        }
        
        return CommitTreeItem(branches: treeBranches, commit: currentCommit)
    }
    
    private func getPaths(for position: Int) -> [GitPath] {
        let currentCommit = commit(for: position)
        let nextCommit: Commit? = self.index(after: position) < endIndex ? commit(for: self.index(after: position)) : nil
        
        paths = paths.filter({ (path) -> Bool in
            switch path.currentStep {
            case .closes(_, _): return false
            default: return true
            }
        })
        
        var newPaths = [GitPath]()
        var standingOpenings = [Int: Int]()
        var shiftWaiters = [Int]()
        var shifts = 0
        
        if !foundParents.contains(currentCommit.objectHash) {
            paths.append(
                GitPath(
                    currentStep: nil,
                    nextStep: .begins(commit: currentCommit),
                    trace: newTrace(),
                    position: position
                )
            )
        }
        
        paths.filter {
            switch $0.currentStep {
            case .closes(_, _): return false
            default: return true
            }
        }
        .forEach {
            newPaths.append($0)
        }
        
        let parents = getParents(for: currentCommit)
        
        guard !parents.isEmpty else {
            return newPaths.map { path in
                GitPath(
                    currentStep: path.nextStep,
                    nextStep: nil,
                    trace: path.trace,
                    position: path.position
                )
            }
        }
        
        for (index, path) in paths.enumerated() {
            calculateNext(
                of: path,
                currentCommit: currentCommit,
                nextCommit: nextCommit,
                index: index,
                position: position,
                standingOpenings: &standingOpenings,
                shiftWaiters: &shiftWaiters,
                shifts: &shifts,
                into: &newPaths)
        }
        
        for (index, path) in newPaths.enumerated() {
            switch path.nextStep {
            case let .fallThrough(toCommit, closes, _, shiftBy):
                path.nextStep = .fallThrough(toCommit: toCommit, closes: closes, opens: standingOpenings[index], shiftBy: shiftBy)
            default: break
            }
        }
        
        paths = newPaths
        
        return newPaths
    }
    
    private func getParents(for commit: Commit) -> [Commit] {
        commit.parents.map {
            let commit = getCommitByHash(hash: $0)
            self.foundParents.insert(commit?.objectHash ?? "")
            return commit
        }.filter { $0 != nil }.map { $0! }
    }
    
    private func getNextStep(for commit: Commit?, nextCommit: Commit?) -> PathStep {
        if let commit = commit, commit == nextCommit {
            return .commit(commit: commit)
        } else {
            return .fallThrough(toCommit: commit, closes: nil, opens: nil, shiftBy: 0)
        }
    }
    
    private func findClosingPathIndex(for commit: Commit, in pathList: [GitPath]) -> Int? {
        return pathList.firstIndex { (other) -> Bool in
            
            switch other.nextStep {
            case .commit(let otherCommit):
                return otherCommit == commit
            default: break
            }
        
            return false
        }
    }
    
    private func findMergePathIndex(for commit: Commit, in pathList: [GitPath]) -> Int? {
        return pathList.firstIndex { (other) -> Bool in
            switch other.currentStep {
            case let .commit(otherCommit):
                return otherCommit == commit
            default: break
            }
            
            switch other.nextStep {
            case .commit(let otherCommit):
                return otherCommit == commit
            default: break
            }
        
            return false
        }
    }
    
    private func findOpenIntoPathIndex(for commit: Commit, nextCommit: Commit?, inBranchParent: Commit?, in pathList: [GitPath], for position: Int) -> Int? {
        return pathList.firstIndex { (other) -> Bool in
            guard other.position == position - 1 else { return false }
            var resultList = [GitPath]()
            var shiftWaiters = [Int]()
            var shifts = 0
            var standingOpenings = [Int: Int]()
            resultList.append(other)
            calculateNext(
                of: other,
                currentCommit: nil,
                nextCommit: nextCommit,
                index: 0,
                position: 0,
                standingOpenings: &standingOpenings,
                shiftWaiters: &shiftWaiters,
                shifts: &shifts,
                into: &resultList
            )
            let next = resultList[0]
            
            switch next.currentStep {
            case .fallThrough(let otherCommit, _, _, _):
                return otherCommit == commit && otherCommit != inBranchParent
            default: break
            }
            
            return false
        }
    }
    
    private func calculateNext(
        of path: GitPath,
        currentCommit: Commit?,
        nextCommit: Commit?,
        index: Int,
        position: Int,
        standingOpenings: inout [Int: Int],
        shiftWaiters: inout [Int],
        shifts: inout Int,
        into result: inout [GitPath]
    ) {
        switch path.nextStep {
        case .commit(let commit), .begins(let commit):
            if commit == currentCommit {
                
                var currentPathParent: Commit? = nil
                
                let parents = getParents(for: commit)

                for parent in parents {
                    var closingPathIndex: Int?
                    var mergePathIndex: Int?
                    var opensIntoPathIndex: Int?
                    if parents.count == 1 {
                        closingPathIndex = findClosingPathIndex(for: parent, in: result.only(for: position))
                    } else {
                        mergePathIndex = findMergePathIndex(for: parent, in: result.only(for: position))
                        if currentPathParent != nil {
                            opensIntoPathIndex = findOpenIntoPathIndex(for: parent, nextCommit: nextCommit, inBranchParent: currentPathParent, in: result, for: position)
                        }
                    }
                    
                    if let closingPathIndex = closingPathIndex, closingPathIndex < index {
                        result[index] = GitPath(currentStep: path.nextStep, nextStep: .closes(to: closingPathIndex, shiftBy: shifts), trace: path.trace, position: position)
                    } else if let mergePathIndex = mergePathIndex {
                        result[mergePathIndex].currentStep = .fallThrough(
                            toCommit: result[mergePathIndex].currentStep?.fallThroughNextCommit!,
                            closes: index,
                            opens: result[mergePathIndex].currentStep?.fallThroughOpens,
                            shiftBy: result[mergePathIndex].currentStep?.fallThroughShiftBy ?? 0
                        )
                    } else if let opensIntoPathIndex = opensIntoPathIndex, opensIntoPathIndex > index {
                        standingOpenings[opensIntoPathIndex] = index
                    } else {
                        if parents.count > 1 && currentPathParent != nil {
                            shiftWaiters.append(result.count)
                            result.append(
                                GitPath(
                                    currentStep: .opens(from: index, shiftBy: shifts),
                                    nextStep: getNextStep(for: parent, nextCommit: nextCommit),
                                    trace: newTrace(),
                                    position: position
                                )
                            )
                        } else {
                            result[index] = GitPath(currentStep: path.nextStep, nextStep: getNextStep(for: parent, nextCommit: nextCommit), trace: path.trace, position: position)
                            currentPathParent = parent
                        }
                    }
                }
            }
        case .fallThrough(let toCommit, _, _, _):
            var closingPathIndex: Int?
            if let commit = toCommit, commit == nextCommit {
                closingPathIndex = findClosingPathIndex(for: commit, in: result)
            }
            
            if let closingPathIndex = closingPathIndex, closingPathIndex < index {
                result[index] = GitPath(
                    currentStep: .fallThrough(
                        toCommit: toCommit,
                        closes: nil,
                        opens: standingOpenings[index],
                        shiftBy: shifts),
                    nextStep: .closes(to: closingPathIndex, shiftBy: shifts),
                    trace: path.trace, position: position
                )
            } else {
                result[index] = GitPath(
                    currentStep: .fallThrough(
                        toCommit: toCommit,
                        closes: nil,
                        opens: standingOpenings[index],
                        shiftBy: shifts
                    ),
                    nextStep: getNextStep(for: toCommit, nextCommit: nextCommit),
                    trace: path.trace,
                    position: position
                )
            }
        case .closes(_, _):
            result[index] = GitPath(currentStep: path.nextStep, nextStep: nil, trace: path.trace, position: position)
            shifts += 1
            for shiftWaiter in shiftWaiters.map({ result[$0] }) {
                switch shiftWaiter.currentStep {
                case .opens(let from, let shiftBy):
                    shiftWaiter.currentStep = .opens(from: from, shiftBy: shiftBy + 1)
                default: break
                }
            }
        case .none: break
        case .some(_): break
        }
    }
    
    private func newTrace() -> Int {
        let trace = currentTrace
        currentTrace += 1
        return trace
    }
}

private extension Array where Element == GitPath {
    func only(for position: Int) -> [GitPath] {
        filter { $0.position == position }
    }
}

public class LogResultParser: GitParser, Parser {
    
    fileprivate var amount: Int?
    
    public static let commitDelimiter = "<<<----%mCommitm%---->>>"
    public static let dataDelimiter = "<<<----%mDatam%---->>>"
    
    /// This parser needs this format to parse the commit correctly.
    public static let parserFormat = "<<<----%%mCommitm%%---->>>%h<<<----%%mDatam%%---->>>%d<<<----%%mDatam%%---->>>%H<<<----%%mDatam%%---->>>%P<<<----%%mDatam%%---->>>%an<<<----%%mDatam%%---->>>%ae<<<----%%mDatam%%---->>>%aD<<<----%%mDatam%%---->>>%cn<<<----%%mDatam%%---->>>%ce<<<----%%mDatam%%---->>>%cD<<<----%%mDatam%%---->>>%s<<<----%%mDatam%%---->>>%B<<<----%%mDatam%%---->>>"
    
    public static let counterFormat = "%h%%"
    
    public typealias Success = LogResult
    
    public init(amount: Int? = nil) {
        self.amount = amount
        super.init()
    }
    
    public func parse(result: String) -> Result<Success, ParseError> {
        if let error = super.parseForIssues(result: result) {
            return .failure(error)
        }
        
        if result.hasPrefix("fatal: "){
            return .success(LogResult(originalOutput: result, commits: nil))
        }
        
        if !result.contains(Self.commitDelimiter) || !result.contains(Self.dataDelimiter) {
            return .failure(ParseError(type: .wrongLogFormat, rawOutput: result))
        }
        
        return .success(LogResult(originalOutput: result, commits: CommitList(base: result, parser: self)))
    }
    
    fileprivate func parse(hunk: String, number: Int) throws -> ([Commit], String) {
        let matches = hunk.split(separator: Self.commitDelimiter, maxSplits: number)

        var commits = [Commit]()
        var commitsLong = [String: Commit]()
        
        var resolved = [""]

        var count = 0
        for match in matches {
            guard count < number else {
                break
            }
            resolved.append(String(match))
            guard !match.isEmpty else {
                continue
            }
            count += 1
            let commit = try parseCommit(commitString: String(match), result: hunk)
            commits.append(commit)
            commitsLong[commit.objectHash] = commit
        }

        return (commits, resolved.joined(separator: Self.commitDelimiter))
    }
    
    private func parseCommit(commitString: String, result: String) throws -> Commit {
        
        let part = commitString.components(separatedBy: Self.dataDelimiter)
        
        let (branches, tags) = parseBranchesAndTags(in: part[1])
        
        let parents: [String] = part[3].split(separator: " ").map({ String($0) }).filter({ !$0.isEmpty })
        
        return Commit(
            objectHash: part[2],
            shortHash: part[0],
            subject: part[10],
            message: part[11],
            author: Person(name: part[4], email: part[5]),
            authorDateString: part[6],
            committer: Person(name: part[7], email: part[8]),
            committerDateString: part[9],
            branches: branches,
            tags: tags,
            parents: parents,
            diff: part[12].trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    private func parseBranchesAndTags(in string: String) -> ([String], [String]) {
        
        var branches = [String]()
        var tags = [String]()
        
        let part = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        part.split(separator: ", ")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .forEach { string in
                if !string.contains(":") {
                    if string.contains("->") {
                        branches.append(String(string.split(separator: " -> ")[1]))
                    } else {
                        branches.append(string)
                    }
                } else {
                    let parts = string.split(separator: ": ")
                    
                    if parts[0] == "tag" {
                        tags.append(String(parts[1]))
                    }
                }
            }
        
        return (branches, tags)
    }
}

extension CommandLog: Parsable {
    
    public typealias Success = LogResult
    
    public var parser: LogResultParser {
        return LogResultParser()
    }
}

extension CommandShow: Parsable {
    
    public typealias Success = LogResult
    
    public var parser: LogResultParser {
        return LogResultParser()
    }
}
