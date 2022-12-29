//
//  File.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

protocol CommandSpec {
    /// The preceeding command.
    var preceeding: CommandSpec? { get set }
    
    /// The command as a string.
    var command: String { get }
    
    /// resolves the command
    func resolve() -> String
}

extension CommandSpec {
    func resolve() -> String {
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
}

class Command: Parametrable {
    var parameter: [Parameter]
    
    var preceeding: CommandSpec?
    
    var command: String {
        ""
    }
    
    required init(
        preceeding: CommandSpec?,
        parameter: [Parameter] = []
    ) {
        self.parameter = parameter
        self.preceeding = preceeding
    }
    
    func copy() -> Self {
        return Self.init(
            preceeding: self.preceeding, parameter: self.parameter
        )
    }
    
    
}
