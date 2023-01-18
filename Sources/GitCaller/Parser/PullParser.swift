//
//  File.swift
//  
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation

public struct PullResult: ParseResult {
    public let originalOutput: String
    
    /// Did the state really change (false if already up to date)
    public let didChange: Bool
}

public class PullResultParser: GitParser, Parser {
    
    public typealias Success = PullResult
    
    override public init() {
        super.init()
    }
    
    public func parse(result: String) -> Result<Success, ParseError> {
        if let error = super.parseForIssues(result: result) {
            return .failure(error)
        }
        
        let pullResult: PullResult
        
        if result.contains(rgx: "Updating.*\nFast-forward") {
            pullResult = PullResult(originalOutput: result, didChange: true)
        } else if result.contains(rgx: "Already up to date.") {
            pullResult = PullResult(originalOutput: result, didChange: false)
        } else {
            return .failure(ParseError(type: .issueParsing, rawOutput: result))
        }
        
        return .success(
            pullResult
        )
    }
}

extension CommandPull: Parsable {
    
    public typealias Success = PullResult
    
    public var parser: PullResultParser {
        return PullResultParser()
    }
}
