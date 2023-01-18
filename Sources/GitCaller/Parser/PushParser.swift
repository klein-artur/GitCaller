//
//  PushParser.swift
//  
//
//  Created by Artur Hellmann on 18.01.23.
//

import Foundation

public struct PushResult: ParseResult {
    public let originalOutput: String
    
    /// Did the state really change (false if already up to date)
    public let didChange: Bool
}

public class PushResultParser: GitParser, Parser {
    
    public typealias Success = PushResult
    
    override public init() {
        super.init()
    }
    
    public func parse(result: String) -> Result<Success, ParseError> {
        if let error = super.parseForIssues(result: result) {
            return .failure(error)
        }
        
        let pushResult: PushResult
        
        if result.contains(rgx: "Everything up-to-date") {
            pushResult = PushResult(originalOutput: result, didChange: false)
        } else if !result.isEmpty {
            pushResult = PushResult(originalOutput: result, didChange: true)
        } else {
            return .failure(ParseError(type: .issueParsing, rawOutput: result))
        }
        
        return .success(
            pushResult
        )
    }
}

extension CommandPush: Parsable {
    
    public typealias Success = PushResult
    
    public var parser: PushResultParser {
        return PushResultParser()
    }
}
