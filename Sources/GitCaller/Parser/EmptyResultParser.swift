//
//  CommitParser.swift
//  
//
//  Created by Artur Hellmann on 16.01.23.
//

import Foundation

public struct EmptyResult: ParseResult {
    public let originalOutput: String
}

public class EmptyResultParser: GitParser, Parser {
    
    public typealias Success = EmptyResult
    
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
        
        let emptyResult = EmptyResult(originalOutput: result)
        
        return .success(
            emptyResult
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
    
    public typealias Success = EmptyResult
    
    public var parser: EmptyResultParser {
        return EmptyResultParser()
    }
}

extension CommandFetch: Parsable {
    
    public typealias Success = EmptyResult
    
    public var parser: EmptyResultParser {
        return EmptyResultParser()
    }
}

extension CommandMerge: Parsable {
    
    public typealias Success = EmptyResult
    
    public var parser: EmptyResultParser {
        return EmptyResultParser()
    }
}

extension CommandMergeTool: Parsable {
    
    public typealias Success = EmptyResult
    
    public var parser: EmptyResultParser {
        return EmptyResultParser()
    }
}
