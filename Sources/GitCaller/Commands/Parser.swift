//
//  Parser.swift
//  
//
//  Created by Artur Hellmann on 30.12.22.
//

import Foundation
import Combine

/// A global parsing error
public enum ParseError: Error {
    
    /// There is an issue parsing.
    case issueParsing
    
    /// Branch name could not be parsed.
    case noBranchNameFound
    
    /// The current directory is not a repository
    case notARepository
}

/// Makes a git command parsable.
public protocol Parsable: CommandSpec {
    associatedtype Success
    associatedtype ParserType: Parser
    
    /// Returns the parser
    var parser: ParserType { get }
    
    /// Parses only the final result of the call and returns it.
    func finalResult() -> AnyPublisher<Success, ParseError>
    
    /// Parses contiiously until the stream finishes and emits every parse state.
    func results() -> AnyPublisher<Self.Success, ParseError>
}

/// A parser base class to parse git results.
public protocol Parser {
    associatedtype Success
    
    /// parses the result by the means of the implementing class.
    func parse(result: String) -> Result<Success, ParseError>
}

public protocol GitParserResult {}

/// A base class for parsers.
public class GitParser {
    func parseForIssues(result: String) -> ParseError? {
        if result.hasPrefix("fatal: not a git repository (or any of the parent directories):") {
            return ParseError.notARepository
        }
        return nil
    }
}

extension Parsable where Success == ParserType.Success {
    
    private func doParsing(on publisher: AnyPublisher<String, Never>) -> AnyPublisher<Success, ParseError> {
        publisher
            .flatMap(maxPublishers: .max(1)) { resultString in
                let result = parser.parse(result: resultString)
                switch result {
                case let .success(status):
                    return Just(status)
                        .setFailureType(to: ParseError.self)
                        .eraseToAnyPublisher()
                case let .failure(error):
                    return Fail<Success, ParseError>(error: error)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func finalResult() -> AnyPublisher<Success, ParseError> {
        return doParsing(on: self.run().last().eraseToAnyPublisher())
    }
    
    public func results() -> AnyPublisher<Success, ParseError> {
        return doParsing(on: self.run())
    }
}
