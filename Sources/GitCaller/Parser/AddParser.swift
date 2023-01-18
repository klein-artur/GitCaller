//
//  AddParser.swift
//  
//
//  Created by Artur Hellmann on 16.01.23.
//

import Foundation

public class AddResultParser: GitParser, Parser {
    
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
        
        let addResult: EmptyResult
        
        if result.isEmpty {
            addResult = EmptyResult(originalOutput: result)
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
    
    public typealias Success = EmptyResult
    
    public var parser: AddResultParser {
        return AddResultParser()
    }
}
