//
//  CommitParser.swift
//  
//
//  Created by Artur Hellmann on 16.01.23.
//

import Foundation

public struct CommitResult: ParseResult {
    public let originalOutput: String
}

public class CommitResultParser: GitParser, Parser {
    
    public typealias Success = CommitResult
    
    override public init() {
        super.init()
    }
    
    public func parse(result: String) -> Result<Success, ParseError> {
        if let error = super.parseForIssues(result: result) {
            return .failure(error)
        }
        
        if let error = checkFatal(result: result) {
            return .failure(error)
        }
        
        let commitResult = CommitResult(originalOutput: result)
        
        return .success(
            commitResult
        )
    }
    
    private func checkFatal(result: String) -> ParseError? {
        guard result.contains("fatal: ") || result.contains("error: ") else {
            return nil
        }
        return ParseError(type: .issueParsing, rawOutput: result)
    }
}

extension CommandCommit: Parsable {
    
    public typealias Success = CommitResult
    
    public var parser: CommitResultParser {
        return CommitResultParser()
    }
}
