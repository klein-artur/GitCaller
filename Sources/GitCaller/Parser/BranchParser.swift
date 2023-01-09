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
    public var deletionSuccessfull: Bool
    
    public var tree: BranchTreeItem? {
        return branches?.parseIntoTree()
    }
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
        
        let branches = result.find(rgx: #"(?:(\*)|\s)\s\(?([^\s\n]+)(?:.*\))?(?:\s*[a-fA-F0-9]{7,12}\s(?:\[(?:ahead\s([0-9]+))?(?:,\s)?(?:behind\s([0-9]+))?\].*)?.*)?(?:\n|\Z)"#)
            .map { result in
                
                let name = result[2]!
                
                var ahead = 0
                if let aheadString = result[3], let aheadInt = Int(aheadString) {
                    ahead = aheadInt
                }
                var behind = 0
                if let behindString = result[4], let behindInt = Int(behindString) {
                    behind = behindInt
                }
                
                return Branch(
                    name: name,
                    isCurrent: !(result[1]?.isEmpty ?? true),
                    isLocal: !name.hasPrefix("remotes/"),
                    behind: behind,
                    ahead: ahead,
                    detached: name == "HEAD"
                )
            }
        
        if branches.isEmpty && result.contains(rgx: #"Deleted branch .*"#) {
            return .success(Success(originalOutput: result, deletionSuccessfull: true))
        }
        
        return .success(
            BranchResult(originalOutput: result, branches: branches, deletionSuccessfull: false)
        )
    }
    
    
}

extension CommandBranch: Parsable {
    
    public typealias Success = BranchResult
    
    public var parser: BranchResultParser {
        return BranchResultParser()
    }
}
