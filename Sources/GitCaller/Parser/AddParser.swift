//
//  AddParser.swift
//  
//
//  Created by Artur Hellmann on 16.01.23.
//

import Foundation

public struct AddResult: ParseResult {
    public let originalOutput: String
}

public class AddResultParser: GitParser, Parser {
    
    public typealias Success = AddResult
    
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
        
        let addResult: AddResult
        
        if result.isEmpty {
            addResult = AddResult(originalOutput: result)
        } else {
            return .failure(ParseError(type: .issueParsing, rawOutput: result))
        }
        
        return .success(
            addResult
        )
    }
    
    private func checkFatal(result: String) -> ParseError? {
        guard result.contains("fatal: ") || result.contains("error: ") else {
            return nil
        }
         
        let type: ParseErrorType
        if result.contains(rgx: "pathspec .* did not match any files") {
            type = .fileNotExists
        } else {
            type = .issueParsing
        }
        return ParseError(type: type, rawOutput: result)
    }
}

extension CommandAdd: Parsable {
    
    public typealias Success = AddResult
    
    public var parser: AddResultParser {
        return AddResultParser()
    }
}
