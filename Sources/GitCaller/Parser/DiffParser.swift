//
//  DiffParser.swift
//  
//
//  Created by Artur Hellmann on 19.01.23.
//

import Foundation

extension ParseErrorType {
    static let diffWithoutContent = ParseErrorType(rawValue: "diffWithoutContent")
    static let unidentifiableDiff = ParseErrorType(rawValue: "unidentifiableDiff")
    static let hunkWithoutChangesets = ParseErrorType(rawValue: "StringhunkWithoutChangesets")
    static let hunkWithoutContent = ParseErrorType(rawValue: "hunkWithoutContent")
}

public struct DiffResult: ParseResult {
    public let diffs: [Diff]
    public let originalOutput: String
}

public enum LineType {
    case left
    case right
    case both
}

public struct HunkLine {
    public let type: LineType
    public let content: String
    
    public var cleanedContent: String {
        var theContent = content
        theContent.remove(at: content.startIndex)
        return theContent
    }
}

public struct Hunk {
    public let header: String
    public let lines: [HunkLine]
    public let original: String
}

public struct Diff {
    public let leftName: String
    public let rightName: String
    public let leftIdent: String
    public let rightIdent: String
    public let hunks: [Hunk]
    public let original: String
}

public class DiffResultParser: GitParser, Parser {
    
    public typealias Success = DiffResult
    
    override public init() {
        super.init()
    }
    
    public func parse(result: String) -> Result<Success, ParseError> {
        if let error = super.parseForIssues(result: result) {
            return .failure(error)
        }
        
        do {
            let diffs = try result.find(rgx: #"\s(?:a\/)?(.*)(?:\sb\/(.*))?\nindex.*\n(.)\3\3\sa\/\1\s*\n(.)\4\4\sb\/(?:\2|\1)\s*\n([\s\S]*?)(?=diff\s--(git|cc)|\Z)"#)
                .map { foundDiff in
                    try parseDiff(in: foundDiff, rawOutput: result)
                }
            
            let diffResult = DiffResult(
                diffs: diffs,
                originalOutput: result
            )
            
            return .success(
                diffResult
            )
            
        } catch let error where error is ParseError {
            return .failure(error as! ParseError)
        } catch {
            return .failure(ParseError(type: .issueParsing, rawOutput: result))
        }
    }
    
    private func parseDiff(in result: RgxResult, rawOutput: String) throws -> Diff {
        guard let leftName = result[1], let leftIdent = result[3], let rightIdent = result[4] else {
            throw ParseError(type: .unidentifiableDiff, rawOutput: rawOutput)
        }
        let rightName = result[2] ?? leftName
        guard let diffContent = result[5] else {
            throw ParseError(type: .diffWithoutContent, rawOutput: rawOutput)
        }
        return Diff(
            leftName: leftName.trimmingCharacters(in: .whitespacesAndNewlines),
            rightName: rightName.trimmingCharacters(in: .whitespacesAndNewlines),
            leftIdent: leftIdent,
            rightIdent: rightIdent,
            hunks: try parseChunks(in: diffContent, leftIdent: leftIdent, rightIdent: rightIdent, rawOutput: rawOutput),
            original: result[0]!
        )
    }
    
    private func parseChunks(in result: String, leftIdent: String, rightIdent: String, rawOutput: String) throws -> [Hunk] {
        try result.find(rgx: #"(@{2,3}\s[-+0-9,\s]+\s@{2,3})([\s\S]*?)(?=\n@@|\Z)"#)
            .map({ result in
                guard let hunkHeader = result[1] else {
                    throw ParseError(type: .hunkWithoutChangesets, rawOutput: rawOutput)
                }
                guard let hunkContent = result[2] else {
                    throw ParseError(type: .hunkWithoutContent, rawOutput: rawOutput)
                }
                return Hunk(
                    header: hunkHeader,
                    lines: parseLines(in: hunkContent, leftIdent: leftIdent, rightIdent: rightIdent),
                    original: result[0]!
                )
            })
    }
    
    private func parseLines(in result: String, leftIdent: String, rightIdent: String) -> [HunkLine] {
        result.split(separator: "\n").map { String($0) }
            .map { line in
                let type: LineType
                if line.hasPrefix(leftIdent) {
                    type = .left
                } else if line.hasPrefix(rightIdent) {
                    type = .right
                } else {
                    type = .both
                }
                return HunkLine(
                    type: type,
                    content: line
                )
            }
    }
}

extension CommandDiff: Parsable {
    
    public typealias Success = DiffResult
    
    public var parser: DiffResultParser {
        return DiffResultParser()
    }
}
