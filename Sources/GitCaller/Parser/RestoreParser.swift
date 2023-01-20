//
//  RestoreParser.swift
//
//
//  Created by Artur Hellmann on 16.01.23.
//

import Foundation

public struct RestoreResult: ParseResult {
    public let originalOutput: String
}

public class RestoreResultParser: GitParser, Parser {
    
    public typealias Success = RestoreResult
    
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
        
        let restoreResult = RestoreResult(originalOutput: result)
        
        return .success(
            restoreResult
        )
    }
    
    private func checkFatal(result: String) -> ParseError? {
        guard result.contains("fatal: ") || result.contains("error: ") else {
            return nil
        }
         
        let type: ParseErrorType
        if result.contains(rgx: "pathspec .* did not match any file") {
            type = .fileNotExists
        } else {
            type = .issueParsing
        }
        return ParseError(type: type, rawOutput: result)
    }
}

extension CommandRestore: Parsable {
    
    public typealias Success = RestoreResult
    
    public var parser: RestoreResultParser {
        return RestoreResultParser()
    }
}
