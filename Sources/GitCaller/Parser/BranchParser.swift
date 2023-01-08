//
//  BranchParser.swift
//  
//
//  Created by Artur Hellmann on 07.01.23.
//

import Foundation

public struct BranchResult: ParseResult {
    public var originalOutput: String
    public var branches: [Branch]?
}

public class BranchResultParser: GitParser, Parser {
    
    public typealias Success = BranchResult
    
    override public init() {
        super.init()
    }
    
    public func parse(result: String) -> Result<Success, ParseError> {
        if let error = super.parseForIssues(result: result) {
            return .failure(error)
        }
        
        let branches = result.find(rgx: #"(?:(\*)|\s)\s\(?([^\s\n]+).*(?:\n|\Z)"#)
            .map { $0[2] ?? "" }
            .filter { !$0.isEmpty && !$0.contains("HEAD ->") }
            .map { name in
                return Branch(
                    name: name,
                    isLocal: name.hasPrefix("remotes/"),
                    detached: name == "HEAD"
                )
            }
        
        return .success(
            BranchResult(originalOutput: result, branches: branches)
        )
    }
}

extension CommandBranch: Parsable {
    
    public typealias Success = BranchResult
    
    public var parser: BranchResultParser {
        return BranchResultParser()
    }
}
