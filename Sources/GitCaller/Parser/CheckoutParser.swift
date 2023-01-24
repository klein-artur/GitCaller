//
//  CheckoutParser.swift
//  
//
//  Created by Artur Hellmann on 09.01.23.
//

import Foundation

public extension ParseErrorType {
    static let branchExsists = ParseErrorType(rawValue: "branchExists")
    static let branchNotExsists = ParseErrorType(rawValue: "branchNotExists")
}

public struct CheckoutResult: ParseResult {
    public let originalOutput: String
    
    /// Did the branch really change (false if already on target)
    public let didChange: Bool
}

public class CheckoutResultParser: GitParser, Parser {
    
    public typealias Success = CheckoutResult
    
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
        
        let checkoutResult: CheckoutResult
        
        if result.contains(rgx: #"Switched to (?:a new )?branch .*"#) {
            checkoutResult = CheckoutResult(originalOutput: result, didChange: true)
        } else if result.contains(rgx: "Already on .*") {
            checkoutResult = CheckoutResult(originalOutput: result, didChange: false)
        } else if result.contains(rgx: #"branch\s.* set up to track .*\nSwitched to a new branch .*"#) {
            checkoutResult = CheckoutResult(originalOutput: result, didChange: true)
        } else if result.contains(rgx: #"Updated [0-9]+ path(?:s)? from .+"#) {
            checkoutResult = CheckoutResult(originalOutput: result, didChange: true)
        } else {
            return .failure(ParseError(type: .issueParsing, rawOutput: result))
        }
        
        return .success(
            checkoutResult
        )
    }
    
    private func checkFatal(result: String) -> ParseError? {
        guard result.contains("fatal: ") || result.contains("error: ") else {
            return nil
        }
         
        let type: ParseErrorType
        if result.contains(rgx: "a branch named .* already exists") {
            type = .branchExsists
        } else if result.contains(rgx: #"pathspec .* did not match any file\(s\) known to git"#) {
            type = .branchNotExsists
        } else {
            type = .issueParsing
        }
        return ParseError(type: type, rawOutput: result)
    }
}

extension CommandCheckout: Parsable {
    
    public typealias Success = CheckoutResult
    
    public var parser: CheckoutResultParser {
        return CheckoutResultParser()
    }
}
