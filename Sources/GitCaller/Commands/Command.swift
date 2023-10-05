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
    
    /// returns the command as a string.
    func toString() -> String
    
    // Resolves the command into a string array representing the argumgents of the git command.
    func resolve(excludeGit: Bool, forString: Bool) -> [String]
    
    /// Applies the alternator if the condition is true.
    func conditional(_ condition: Bool, alternator: (Self) -> Self) -> Self
    
    /// Applies the alternator if the optional is not nil, passes the object to the alternator.
    func conditionalLet<T>(_ optional: T?, alternator: (Self, T) -> Self) -> Self
    
    /// Applies the alternator if the optional is not nil, passes the object to the alternator.
    func forEach<T>(_ list: Array<T>, alternator: (Self, T) -> Self) -> Self
}

extension CommandSpec {
    public func resolve(excludeGit: Bool = true, forString: Bool = false) -> [String] {
        if let rawCommand = self as? RawCommand {
            var cleanedCommand = rawCommand.splitCommandLineArguments()
            if cleanedCommand.first == "git" {
                cleanedCommand.removeFirst()
            }
            return cleanedCommand
        } else  {
            let (commands, parameter) = internalResolve()
            
            return commands.filter({ !excludeGit || $0 != "git" }) + parameter.map { $0.getCommand(forString: forString) }
        }
    }
    
    private func internalResolve() -> ([String], [Parameter]) {
        
        var commands = [String]()
        var parameter = [Parameter]()
        
        if let preceeding = self.preceeding {
            (commands, parameter) = preceeding.internalResolve()
        }
        
        commands.append(self.command)
        
        if let selfParametrable = self as? (any ParametrableCommandSpec) {
            parameter.append(contentsOf: selfParametrable.parameter)
        }
        
        return (commands, parameter)
    }
    
    public func toString() -> String {
        self.resolve(excludeGit: false, forString: true).joined(separator: " ")
    }
    
    public func conditional(_ condition: Bool, alternator: (Self) -> Self) -> Self {
        if condition {
            return alternator(self)
        } else {
            return self
        }
    }
    
    public func conditionalLet<T>(_ optional: T?, alternator: (Self, T) -> Self) -> Self {
        if let opt = optional {
            return alternator(self, opt)
        } else {
            return self
        }
    }
    
    public func forEach<T>(_ list: Array<T>, alternator: (Self, T) -> Self) -> Self {
        var newCommand = self
        for element in list {
            newCommand = alternator(newCommand, element)
        }
        return newCommand
    }
}
