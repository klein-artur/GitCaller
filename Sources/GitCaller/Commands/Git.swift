//
//  Git.swift
//  
//
//  Created by Artur Hellmann on 29.12.22.
//

import Foundation

public final class RawCommand: CommandSpec {
    public let command: String
    
    init(_ raw: String, git: Git) {
        self.command = raw
        self.preceeding = git
    }
    
    public var preceeding: (any CommandSpec)? = nil
}

public final class Git: CommandSpec {
    public let command = "git"
    public var preceeding: (any CommandSpec)? = nil
    
    public init() { }
}

public extension Git {
    static func raw(_ raw: String) -> any CommandSpec {
        return RawCommand(raw, git: Git())
    }
}

extension RawCommand {
    func splitCommandLineArguments() -> [String] {
        var arguments: [String] = []
        var currentArgument = ""
        var escapeNextCharacter = false
        var insideQuotes = false
        
        for char in self.command {
            if char == "\\" {
                escapeNextCharacter = true
            } else if char == "\"" && !escapeNextCharacter {
                insideQuotes = !insideQuotes
            } else if char == " " && !insideQuotes && !escapeNextCharacter {
                arguments.append(currentArgument)
                currentArgument = ""
            } else {
                currentArgument.append(char)
                escapeNextCharacter = false
            }
        }
        
        if !currentArgument.isEmpty {
            arguments.append(currentArgument)
        }
        
        return arguments
    }

}
