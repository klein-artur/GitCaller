//
//  Command.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public protocol CommandSpec {
    /// The preceeding command.
    var preceeding: (any CommandSpec)? { get set }
    
    /// The command as a string.
    var command: String { get }
    
    /// resolves the command
    func resolve() -> String
    
    /// Applies the alternator if the condition is true.
    func conditional(_ condition: Bool, alternator: (Self) -> Self) -> Self
    
    /// Applies the alternator if the optional is not nil, passes the object to the alternator.
    func ifLet<T>(_ optional: T?, alternator: (Self, T) -> Self) -> Self
}

extension CommandSpec {
    public func resolve() -> String {
        let (command, parameter) = internalResolve()
        let parameterString = parameter.map({ $0.command }).joined(separator: " ")
        
        if !parameterString.isEmpty {
            return "\(command) \(parameterString)"
        } else {
            return command
        }
    }
    
    private func internalResolve() -> (String, [Parameter]) {
        let resultCommand: String
        if let preceeding = preceeding {
            resultCommand = "\(preceeding.resolve()) \(command)"
        } else {
            resultCommand = command
        }
        
        var parameter: [Parameter] = []
        
        if let preceeding = self.preceeding as? (any Parametrable) {
            parameter.append(contentsOf: preceeding.parameter)
        }
        
        if let selfParametrable = self as? (any Parametrable) {
            parameter.append(contentsOf: selfParametrable.parameter)
        }
        
        return (resultCommand, parameter)
    }
    
    public func conditional(_ condition: Bool, alternator: (Self) -> Self) -> Self {
        if condition {
            return alternator(self)
        } else {
            return self
        }
    }
    
    public func ifLet<T>(_ optional: T?, alternator: (Self, T) -> Self) -> Self {
        if let opt = optional {
            return alternator(self, opt)
        } else {
            return self
        }
    }
}

public class Command: Parametrable {
    public var parameter: [Parameter]
    
    public var preceeding: (any CommandSpec)?
    
    public var command: String {
        ""
    }
    
    required init(
        preceeding: (any CommandSpec)?,
        parameter: [Parameter] = []
    ) {
        self.parameter = parameter
        self.preceeding = preceeding
    }
    
    public func copy() -> Self {
        return Self.init(
            preceeding: self.preceeding, parameter: self.parameter
        )
    }
    
    
}
