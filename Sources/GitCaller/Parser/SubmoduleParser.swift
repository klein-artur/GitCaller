//
//  SubmoduleParser.swift
//
//
//  Created by Artur Hellmann on 07.10.23.
//

import Foundation

public extension ParseErrorType {
    /// The line from the git submodule command output doesn't have the correct format.
    static let invalidLineFormat = ParseErrorType(rawValue: "invalidLineFormat")
}


public struct SubmoduleResult: ParseResult {
    public var originalOutput: String
    public var submodules: [Submodule]
    
    public struct Submodule {
        public let path: String
        public let commitHash: String
        public let state: State
        
        public enum State: String {
            case clean = " "
            case modified = "+"
            case missing = "-"
            case conflicted = "U"
            
            init?(from symbol: Character) {
                switch symbol {
                case " ": self = .clean
                case "+": self = .modified
                case "-": self = .missing
                case "U": self = .conflicted
                default: return nil
                }
            }
        }
    }
}

public class SubmoduleParser: GitParser, Parser {
    
    public typealias Success = SubmoduleResult
    
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
        
        do {
            let parsed = try parseSubmodules(input: result)
            return .success(parsed)
        } catch let error as ParseError {
            return .failure(error)
        } catch {
            // Catch any other types of errors
            return .failure(ParseError(type: .issueParsing, rawOutput: result))
        }
    }
    
    private func parseSubmodules(input: String) throws -> SubmoduleResult {
        let lines = input.split(separator: "\n")
        var submodules: [SubmoduleResult.Submodule] = []
        let pattern = "([\\+\\-U ])\\s*([a-fA-F0-9]+)\\s*(.+)\\s*\\(.*\\)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        for line in lines {
            let nsLine = line as NSString
            guard let match = regex.firstMatch(in: nsLine as String, options: [], range: NSRange(location: 0, length: nsLine.length)) else {
                throw ParseError(type: .invalidLineFormat, rawOutput: String(line))
            }
            
            let stateSymbol = Character(nsLine.substring(with: match.range(at: 1)))
            let commitHash = nsLine.substring(with: match.range(at: 2))
            var path = nsLine.substring(with: match.range(at: 3))
            path = path.trimmingCharacters(in: .whitespaces)
            
            guard let state = SubmoduleResult.Submodule.State(from: stateSymbol) else {
                throw ParseError(type: .issueParsing, rawOutput: String(line))
            }
            
            let submodule = SubmoduleResult.Submodule(path: path, commitHash: commitHash, state: state)
            submodules.append(submodule)
        }
        
        let result = SubmoduleResult(originalOutput: input, submodules: submodules)
        return result
    }
    
    private func checkFatal(result: String) -> ParseError? {
        guard result.hasPrefix("fatal: ") || result.hasPrefix("error: ") else {
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

extension CommandSubmodule: Parsable {
    
    public typealias Success = SubmoduleResult
    
    public var parser: SubmoduleParser {
        return SubmoduleParser()
    }
}
