//
//  Parser.swift
//  
//
//  Created by Artur Hellmann on 30.12.22.
//

import Foundation
import Combine

/// Parsing error type
public struct ParseErrorType: RawRepresentable, Equatable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// There is an issue parsing.
    public static let issueParsing = ParseErrorType(rawValue: "issueParsing")
    
    /// Branch name could not be parsed.
    public static let noBranchNameFound = ParseErrorType(rawValue: "noBranchNameFound")
    
    /// The current directory is not a repository
    public static let notARepository = ParseErrorType(rawValue: "notARepository")
    
    /// Trying to parse a commit without a hash
    public static let commitWithoutCommmitHash = ParseErrorType(rawValue: "commitWithoutCommmitHash")
    
    /// Trying to parse a commit without author
    public static let commitWithoutAuthor = ParseErrorType(rawValue: "commitWithoutAuthor")
    
    /// Trying to parse a commit without date
    public static let commitWithoutDate = ParseErrorType(rawValue: "commitWithoutDate")
    
    /// The log has wrong format. Please use the correct pretty format.
    public static let wrongLogFormat = ParseErrorType(rawValue: "wrongLogFormat")
    
    /// The log has wrong format. Please use the correct pretty format.
    public static let fileNotExists = ParseErrorType(rawValue: "fileNotExists")
}

/// A parse error
public struct ParseError: Error {
    public let type: ParseErrorType
    public let rawOutput: String
}

/// A protocol all parse results have to conform to.
public protocol ParseResult {
    var originalOutput: String { get }
}

/// Makes a git command parsable.
public protocol Parsable: CommandSpec {
    associatedtype Success: ParseResult
    associatedtype ParserType: Parser
    
    /// Returns the parser
    var parser: ParserType { get }
    
    /// Parses only the final result of the call and returns it.
    func finalResult(predefinedInput: String?) async throws -> Success
    
    /// Parses contiiously until the stream finishes and emits every parse state.
    func results(predefinedInput: String?) -> AnyPublisher<Self.Success, ParseError>
}

/// A parser base class to parse git results.
public protocol Parser {
    associatedtype Success: ParseResult
    
    /// parses the result by the means of the implementing class.
    func parse(result: String) -> Result<Success, ParseError>
    
}

/// A base class for parsers.
public class GitParser {
    func parseForIssues(result: String) -> ParseError? {
        if result.hasPrefix("fatal: not a git repository (or any of the parent directories):") {
            return ParseError(type: .notARepository, rawOutput: result)
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
    
    public func finalResult(predefinedInput: String? = nil) async throws -> Success {
        let result = try await self.runAsync(predefinedInput: predefinedInput)
        let parsedResult = parser.parse(result: result)
        switch parsedResult {
        case let .success(parsedElement):
            return parsedElement
        case let .failure(error):
            throw error
        }
    }
    
    public func results(predefinedInput: String? = nil) -> AnyPublisher<Success, ParseError> {
        return doParsing(on: self.run(predefinedInput: predefinedInput))
    }
}

extension Parsable where Success == EmptyResult {
    
    public func ignoreResult(predefinedInput: String? = nil) async throws {
        _ = try await finalResult(predefinedInput: predefinedInput)
    }
    
}
